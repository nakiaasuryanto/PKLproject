/**
 * Prospectings Routes (VG-compatible)
 *
 * API endpoints untuk manage prospecting data.
 * Struktur mengikuti vg_prospecting:
 * - instansis (companies)
 * - kontaks (contacts, linked to instansi)
 * - prospectings (linked to kontak)
 */

import express from 'express';
import db from '../db.js';

const router = express.Router();

// =============================================================================
// PROSPECTINGS
// =============================================================================

/**
 * GET /prospectings
 * Get all prospectings with kontak and instansi info
 */
router.get('/', async (req, res) => {
  try {
    const { status, search } = req.query;

    let query = `
      SELECT
        p.id,
        p.kontak_id,
        p.status,
        p.produk,
        p.bahan,
        p.jumlah,
        p.harga_satuan,
        p.omzet,
        p.saluran,
        p.tanggal,
        p.tanggal_closing,
        p.metode_pembayaran,
        p.created_at,
        p.updated_at,
        k.nama as kontak_nama,
        k.telepon as kontak_telepon,
        k.email as kontak_email,
        i.id as instansi_id,
        i.nama as instansi_nama,
        i.jenis as instansi_jenis,
        i.unit_bisnis,
        va.va_number,
        va.amount as va_amount,
        va.status as va_status,
        va.paid_at
      FROM prospectings p
      LEFT JOIN kontaks k ON k.id = p.kontak_id
      LEFT JOIN instansis i ON i.id = k.instansi_id
      LEFT JOIN virtual_accounts va ON va.prospecting_id = p.id
      WHERE p.deleted_at IS NULL
    `;

    const params = [];

    if (status) {
      query += ' AND p.status = ?';
      params.push(status);
    }

    if (search) {
      query += ' AND (k.nama LIKE ? OR i.nama LIKE ? OR p.produk LIKE ?)';
      const searchTerm = `%${search}%`;
      params.push(searchTerm, searchTerm, searchTerm);
    }

    query += ' ORDER BY p.updated_at DESC';

    const [rows] = await db.query(query, params);

    res.json({
      success: true,
      data: rows
    });
  } catch (err) {
    console.error('[Prospectings] Error:', err);
    res.status(500).json({
      success: false,
      message: err.message
    });
  }
});

/**
 * GET /prospectings/stats
 * Get prospecting statistics
 */
router.get('/stats', async (req, res) => {
  try {
    const [stats] = await db.query(`
      SELECT
        COUNT(*) as total,
        SUM(CASE WHEN status = 'New' THEN 1 ELSE 0 END) as new_count,
        SUM(CASE WHEN status = 'Follow Up' THEN 1 ELSE 0 END) as followup,
        SUM(CASE WHEN status = 'Closing' THEN 1 ELSE 0 END) as closing,
        SUM(CASE WHEN status = 'Closed' THEN 1 ELSE 0 END) as closed,
        SUM(CASE WHEN status = 'Lost' THEN 1 ELSE 0 END) as lost,
        COALESCE(SUM(omzet), 0) as total_omzet,
        COALESCE(SUM(CASE WHEN status = 'Closed' THEN omzet ELSE 0 END), 0) as closed_omzet
      FROM prospectings
      WHERE deleted_at IS NULL
    `);

    const [vaStats] = await db.query(`
      SELECT
        COUNT(*) as total_va,
        SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) as active_va,
        SUM(CASE WHEN status = 'PAID' THEN 1 ELSE 0 END) as paid_va,
        COALESCE(SUM(CASE WHEN status = 'PAID' THEN amount ELSE 0 END), 0) as total_revenue
      FROM virtual_accounts
    `);

    res.json({
      success: true,
      data: {
        prospecting: stats[0],
        va: vaStats[0]
      }
    });
  } catch (err) {
    console.error('[Prospectings] Stats error:', err);
    res.status(500).json({
      success: false,
      message: err.message
    });
  }
});

/**
 * GET /prospectings/:id
 * Get single prospecting detail
 */
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT
        p.*,
        k.nama as kontak_nama,
        k.telepon as kontak_telepon,
        k.email as kontak_email,
        i.id as instansi_id,
        i.nama as instansi_nama,
        i.jenis as instansi_jenis,
        i.alamat as instansi_alamat,
        i.unit_bisnis,
        va.id as va_id,
        va.va_number,
        va.amount as va_amount,
        va.status as va_status,
        va.paid_at,
        va.expires_at,
        va.created_at as va_created_at
      FROM prospectings p
      LEFT JOIN kontaks k ON k.id = p.kontak_id
      LEFT JOIN instansis i ON i.id = k.instansi_id
      LEFT JOIN virtual_accounts va ON va.prospecting_id = p.id
      WHERE p.id = ? AND p.deleted_at IS NULL
    `, [req.params.id]);

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Prospecting not found'
      });
    }

    // Get followups
    const [followups] = await db.query(
      'SELECT * FROM followups WHERE prospecting_id = ? AND deleted_at IS NULL ORDER BY created_at DESC',
      [req.params.id]
    );

    res.json({
      success: true,
      data: {
        ...rows[0],
        followups
      }
    });
  } catch (err) {
    console.error('[Prospectings] Error:', err);
    res.status(500).json({
      success: false,
      message: err.message
    });
  }
});

/**
 * POST /prospectings
 * Create new prospecting with kontak, instansi, AND customer (integrated)
 */
router.post('/', async (req, res) => {
  const connection = await db.getConnection();

  try {
    await connection.beginTransaction();

    const {
      // Instansi data
      instansi_nama,
      instansi_jenis,
      instansi_alamat,
      unit_bisnis,
      // Kontak data
      kontak_nama,
      kontak_telepon,
      kontak_email,
      kontak_jabatan,
      // Prospecting data
      produk,
      bahan,
      jumlah,
      harga_satuan,
      saluran,
      status = 'New',
      user_id = 1
    } = req.body;

    // 1. Create or find instansi
    let instansi_id = null;
    if (instansi_nama) {
      const [existing] = await connection.query(
        'SELECT id FROM instansis WHERE nama = ? AND deleted_at IS NULL LIMIT 1',
        [instansi_nama]
      );

      if (existing.length > 0) {
        instansi_id = existing[0].id;
      } else {
        const [result] = await connection.query(
          'INSERT INTO instansis (nama, jenis, alamat, unit_bisnis) VALUES (?, ?, ?, ?)',
          [instansi_nama, instansi_jenis || null, instansi_alamat || null, unit_bisnis || null]
        );
        instansi_id = result.insertId;
      }
    }

    // 2. Create kontak
    const [kontakResult] = await connection.query(
      'INSERT INTO kontaks (instansi_id, nama, telepon, email, jabatan) VALUES (?, ?, ?, ?, ?)',
      [instansi_id, kontak_nama, kontak_telepon || null, kontak_email || null, kontak_jabatan || null]
    );
    const kontak_id = kontakResult.insertId;

    // 3. Create customer (integration with sales system)
    let customer_id = null;
    let customerCode = null;
    try {
      // Generate customer code
      const [lastCustomer] = await connection.query(
        'SELECT customer_code FROM customers ORDER BY id DESC LIMIT 1'
      );
      if (lastCustomer.length === 0) {
        customerCode = 'CUST001';
      } else {
        const lastCode = lastCustomer[0].customer_code;
        const lastNumber = parseInt(lastCode.replace('CUST', '')) || 0;
        customerCode = `CUST${String(lastNumber + 1).padStart(3, '0')}`;
      }

      // Determine customer type based on instansi
      const customerType = instansi_nama ? 'COMPANY' : 'INDIVIDUAL';

      // Try with kontak_id first, fallback to without
      try {
        const [customerResult] = await connection.query(
          `INSERT INTO customers
           (kontak_id, customer_code, name, company_name, email, phone, address, customer_type, status)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'active')`,
          [kontak_id, customerCode, kontak_nama, instansi_nama || null,
           kontak_email || null, kontak_telepon || null, instansi_alamat || null, customerType]
        );
        customer_id = customerResult.insertId;
      } catch (colErr) {
        // kontak_id column might not exist, try without it
        const [customerResult] = await connection.query(
          `INSERT INTO customers
           (customer_code, name, company_name, email, phone, address, customer_type, status)
           VALUES (?, ?, ?, ?, ?, ?, ?, 'active')`,
          [customerCode, kontak_nama, instansi_nama || null,
           kontak_email || null, kontak_telepon || null, instansi_alamat || null, customerType]
        );
        customer_id = customerResult.insertId;
      }
    } catch (custErr) {
      console.log('[Prospectings] Customer creation skipped:', custErr.message);
    }

    // 4. Calculate omzet
    const omzet = (parseFloat(jumlah) || 0) * (parseFloat(harga_satuan) || 0);

    // 5. Create prospecting
    const [prospectingResult] = await connection.query(
      `INSERT INTO prospectings
       (kontak_id, status, produk, bahan, jumlah, harga_satuan, omzet, saluran, tanggal, user_id)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURDATE(), ?)`,
      [kontak_id, status, produk || null, bahan || null, jumlah || null,
       harga_satuan || 0, omzet, saluran || null, user_id]
    );

    await connection.commit();

    res.status(201).json({
      success: true,
      data: {
        id: prospectingResult.insertId,
        kontak_id,
        instansi_id,
        customer_id,
        customer_code: customerCode,
        kontak_nama,
        instansi_nama,
        status
      }
    });
  } catch (err) {
    await connection.rollback();
    console.error('[Prospectings] Create error:', err);
    res.status(500).json({
      success: false,
      message: err.message
    });
  } finally {
    connection.release();
  }
});

/**
 * PATCH /prospectings/:id/status
 * Update prospecting status only
 */
router.patch('/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    if (!status) {
      return res.status(400).json({
        success: false,
        message: 'Status is required'
      });
    }

    // If status is Closed, also set tanggal_closing
    let query = 'UPDATE prospectings SET status = ?';
    const params = [status];

    if (status === 'Closed') {
      query += ', tanggal_closing = CURDATE(), closed = ?';
      params.push('Paid');
    }

    query += ' WHERE id = ? AND deleted_at IS NULL';
    params.push(id);

    const [result] = await db.query(query, params);

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: 'Prospecting not found'
      });
    }

    res.json({
      success: true,
      data: { id, status }
    });
  } catch (err) {
    console.error('[Prospectings] Status update error:', err);
    res.status(500).json({
      success: false,
      message: err.message
    });
  }
});

/**
 * DELETE /prospectings/:id
 * Soft delete prospecting
 */
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    await db.query(
      'UPDATE prospectings SET deleted_at = NOW() WHERE id = ?',
      [id]
    );

    res.json({
      success: true,
      message: 'Prospecting deleted'
    });
  } catch (err) {
    console.error('[Prospectings] Delete error:', err);
    res.status(500).json({
      success: false,
      message: err.message
    });
  }
});

// =============================================================================
// INSTANSIS (Companies)
// =============================================================================

router.get('/instansis/list', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM instansis WHERE deleted_at IS NULL ORDER BY nama'
    );
    res.json({ success: true, data: rows });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// =============================================================================
// KONTAKS (Contacts)
// =============================================================================

router.get('/kontaks/list', async (req, res) => {
  try {
    const { instansi_id } = req.query;
    let query = `
      SELECT k.*, i.nama as instansi_nama
      FROM kontaks k
      LEFT JOIN instansis i ON i.id = k.instansi_id
      WHERE k.deleted_at IS NULL
    `;
    const params = [];

    if (instansi_id) {
      query += ' AND k.instansi_id = ?';
      params.push(instansi_id);
    }

    query += ' ORDER BY k.nama';

    const [rows] = await db.query(query, params);
    res.json({ success: true, data: rows });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

export default router;

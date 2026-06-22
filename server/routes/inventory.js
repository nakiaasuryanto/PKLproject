import express from 'express';
import db from '../db.js';

const router = express.Router();

router.get('/stock', async (req, res) => {
  try {
    const { location_id, low_stock } = req.query;

    let query = `
      SELECT
        pcs.id as product_color_size_id,
        p.name as product_name,
        c.name as color_name,
        s.name as size_name,
        l.name as location_name,
        sb.quantity,
        sb.moving_avg_cost,
        pcs.sku
      FROM stock_balances sb
      JOIN product_color_sizes pcs ON sb.product_color_size_id = pcs.id
      JOIN product_colors pc ON pcs.product_color_id = pc.id
      JOIN products p ON pc.product_id = p.id
      JOIN colors c ON pc.color_id = c.id
      JOIN sizes s ON pcs.size_id = s.id
      JOIN locations l ON sb.location_id = l.id
      WHERE 1=1
    `;

    const params = [];

    if (location_id) {
      query += ' AND sb.location_id = ?';
      params.push(location_id);
    }

    if (low_stock === 'true') {
      query += ' AND sb.quantity < 10';
    }

    query += ' ORDER BY p.name, c.name, s.sort_order';

    const [stock] = await db.query(query, params);

    res.json({ success: true, data: stock });
  } catch (error) {
    console.error('Error fetching stock:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/movements', async (req, res) => {
  try {
    const { start_date, end_date, product_id, location_id, limit = 100 } = req.query;

    let query = `
      SELECT
        sm.*,
        p.name as product_name,
        c.name as color_name,
        s.name as size_name,
        l.name as location_name
      FROM stock_movements sm
      JOIN product_color_sizes pcs ON sm.product_color_size_id = pcs.id
      JOIN product_colors pc ON pcs.product_color_id = pc.id
      JOIN products p ON pc.product_id = p.id
      JOIN colors c ON pc.color_id = c.id
      JOIN sizes s ON pcs.size_id = s.id
      JOIN locations l ON sm.location_id = l.id
      WHERE 1=1
    `;

    const params = [];

    if (start_date) {
      query += ' AND sm.movement_date >= ?';
      params.push(start_date);
    }

    if (end_date) {
      query += ' AND sm.movement_date <= ?';
      params.push(end_date);
    }

    if (location_id) {
      query += ' AND sm.location_id = ?';
      params.push(location_id);
    }

    query += ' ORDER BY sm.movement_date DESC, sm.created_at DESC LIMIT ?';
    params.push(parseInt(limit));

    const [movements] = await db.query(query, params);

    res.json({ success: true, data: movements });
  } catch (error) {
    console.error('Error fetching movements:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.post('/movements', async (req, res) => {
  const connection = await db.getConnection();

  try {
    await connection.beginTransaction();

    const {
      product_color_size_id,
      location_id,
      movement_type,
      quantity,
      reason_code,
      notes,
      created_by
    } = req.body;

    const movement_date = new Date();

    const [result] = await connection.query(
      `INSERT INTO stock_movements
       (product_color_size_id, location_id, movement_type, quantity, reason_code, notes, movement_date, created_by)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [product_color_size_id, location_id, movement_type, quantity, reason_code, notes, movement_date, created_by]
    );

    const quantityChange = movement_type === 'IN' ? quantity : -quantity;

    await connection.query(
      `INSERT INTO stock_balances (product_color_size_id, location_id, quantity)
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE quantity = quantity + ?`,
      [product_color_size_id, location_id, quantityChange, quantityChange]
    );

    await connection.commit();

    res.status(201).json({
      success: true,
      data: { id: result.insertId }
    });
  } catch (error) {
    await connection.rollback();
    console.error('Error creating movement:', error);
    res.status(500).json({ success: false, error: error.message });
  } finally {
    connection.release();
  }
});

router.post('/transfer', async (req, res) => {
  const connection = await db.getConnection();

  try {
    await connection.beginTransaction();

    const {
      product_color_size_id,
      from_location_id,
      to_location_id,
      quantity,
      notes,
      created_by
    } = req.body;

    if (from_location_id === to_location_id) {
      return res.status(400).json({ success: false, error: 'Lokasi asal dan tujuan tidak boleh sama' });
    }

    // Check stock availability at source location
    const [[currentStock]] = await connection.query(
      'SELECT quantity FROM stock_balances WHERE product_color_size_id = ? AND location_id = ?',
      [product_color_size_id, from_location_id]
    );

    if (!currentStock || currentStock.quantity < quantity) {
      return res.status(400).json({
        success: false,
        error: `Stok tidak cukup. Tersedia: ${currentStock?.quantity || 0}`
      });
    }

    const movement_date = new Date();

    // Create OUT movement from source
    await connection.query(
      `INSERT INTO stock_movements
       (product_color_size_id, location_id, movement_type, quantity, reason_code, notes, movement_date, created_by)
       VALUES (?, ?, 'OUT', ?, 'TRANSFER_OUT', ?, ?, ?)`,
      [product_color_size_id, from_location_id, quantity, notes, movement_date, created_by]
    );

    // Create IN movement to destination
    await connection.query(
      `INSERT INTO stock_movements
       (product_color_size_id, location_id, movement_type, quantity, reason_code, notes, movement_date, created_by)
       VALUES (?, ?, 'IN', ?, 'TRANSFER_IN', ?, ?, ?)`,
      [product_color_size_id, to_location_id, quantity, notes, movement_date, created_by]
    );

    // Update source location stock (decrease)
    await connection.query(
      'UPDATE stock_balances SET quantity = quantity - ? WHERE product_color_size_id = ? AND location_id = ?',
      [quantity, product_color_size_id, from_location_id]
    );

    // Update destination location stock (increase or insert)
    await connection.query(
      `INSERT INTO stock_balances (product_color_size_id, location_id, quantity)
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE quantity = quantity + ?`,
      [product_color_size_id, to_location_id, quantity, quantity]
    );

    await connection.commit();

    res.status(201).json({
      success: true,
      data: { message: `Berhasil transfer ${quantity} unit` }
    });
  } catch (error) {
    await connection.rollback();
    console.error('Error transferring stock:', error);
    res.status(500).json({ success: false, error: error.message });
  } finally {
    connection.release();
  }
});

router.get('/locations', async (req, res) => {
  try {
    const [locations] = await db.query('SELECT * FROM locations ORDER BY name');
    res.json({ success: true, data: locations });
  } catch (error) {
    console.error('Error fetching locations:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/locations/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const [locations] = await db.query('SELECT * FROM locations WHERE id = ?', [id]);

    if (locations.length === 0) {
      return res.status(404).json({ success: false, error: 'Location not found' });
    }

    const [stock] = await db.query(`
      SELECT
        pcs.id as product_color_size_id,
        p.name as product_name,
        c.name as color_name,
        c.hex_code,
        s.name as size_name,
        sb.quantity,
        pcs.sku
      FROM stock_balances sb
      JOIN product_color_sizes pcs ON sb.product_color_size_id = pcs.id
      JOIN product_colors pc ON pcs.product_color_id = pc.id
      JOIN products p ON pc.product_id = p.id
      JOIN colors c ON pc.color_id = c.id
      JOIN sizes s ON pcs.size_id = s.id
      WHERE sb.location_id = ?
      ORDER BY p.name, c.name, s.sort_order
    `, [id]);

    res.json({
      success: true,
      data: {
        location: locations[0],
        stock: stock
      }
    });
  } catch (error) {
    console.error('Error fetching location:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/products', async (req, res) => {
  try {
    const [products] = await db.query(`
      SELECT DISTINCT p.id as product_id, p.name as product_name, p.category
      FROM products p
      JOIN product_colors pc ON p.id = pc.product_id
      JOIN product_color_sizes pcs ON pc.id = pcs.product_color_id
      ORDER BY p.name
    `);
    res.json({ success: true, data: products });
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/colors', async (req, res) => {
  try {
    const [colors] = await db.query('SELECT * FROM colors ORDER BY name');
    res.json({ success: true, data: colors });
  } catch (error) {
    console.error('Error fetching colors:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/colors/:productId', async (req, res) => {
  try {
    const { productId } = req.params;
    const [colors] = await db.query(`
      SELECT DISTINCT c.id as color_id, c.name as color_name, c.hex_code
      FROM colors c
      JOIN product_colors pc ON c.id = pc.color_id
      WHERE pc.product_id = ?
      ORDER BY c.name
    `, [productId]);
    res.json({ success: true, data: colors });
  } catch (error) {
    console.error('Error fetching colors for product:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/sizes', async (req, res) => {
  try {
    const [sizes] = await db.query('SELECT * FROM sizes ORDER BY sort_order');
    res.json({ success: true, data: sizes });
  } catch (error) {
    console.error('Error fetching sizes:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/sizes/:productId/:colorId', async (req, res) => {
  try {
    const { productId, colorId } = req.params;
    const [sizes] = await db.query(`
      SELECT
        s.id as size_id,
        s.name as size_name,
        pcs.id as variant_id,
        pcs.sku,
        COALESCE(SUM(sb.quantity), 0) as total_qty
      FROM sizes s
      JOIN product_color_sizes pcs ON s.id = pcs.size_id
      JOIN product_colors pc ON pcs.product_color_id = pc.id
      LEFT JOIN stock_balances sb ON pcs.id = sb.product_color_size_id
      WHERE pc.product_id = ? AND pc.color_id = ?
      GROUP BY s.id, s.name, pcs.id, pcs.sku
      ORDER BY s.sort_order
    `, [productId, colorId]);
    res.json({ success: true, data: sizes });
  } catch (error) {
    console.error('Error fetching sizes for product/color:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/variants', async (req, res) => {
  try {
    const [variants] = await db.query(`
      SELECT
        pcs.id as variant_id,
        pcs.sku,
        p.id as product_id,
        p.name as product_name,
        c.id as color_id,
        c.name as color_name,
        c.hex_code,
        s.id as size_id,
        s.name as size_name,
        COALESCE(SUM(sb.quantity), 0) as total_stock
      FROM product_color_sizes pcs
      JOIN product_colors pc ON pcs.product_color_id = pc.id
      JOIN products p ON pc.product_id = p.id
      JOIN colors c ON pc.color_id = c.id
      JOIN sizes s ON pcs.size_id = s.id
      LEFT JOIN stock_balances sb ON pcs.id = sb.product_color_size_id
      GROUP BY pcs.id, pcs.sku, p.id, p.name, c.id, c.name, c.hex_code, s.id, s.name
      ORDER BY p.name, c.name, s.sort_order
    `);
    res.json({ success: true, data: variants });
  } catch (error) {
    console.error('Error fetching variants:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.post('/validate-import', async (req, res) => {
  try {
    const { rows } = req.body;

    if (!rows || !Array.isArray(rows) || rows.length === 0) {
      return res.status(400).json({ success: false, error: 'No data provided' });
    }

    const validationResults = [];
    const [products] = await db.query('SELECT id, name FROM products');
    const [colors] = await db.query('SELECT id, name FROM colors');
    const [sizes] = await db.query('SELECT id, name FROM sizes');
    const [locations] = await db.query('SELECT id, name FROM locations');

    const productMap = Object.fromEntries(products.map(p => [p.name.toLowerCase(), p.id]));
    const colorMap = Object.fromEntries(colors.map(c => [c.name.toLowerCase(), c.id]));
    const sizeMap = Object.fromEntries(sizes.map(s => [s.name.toLowerCase(), s.id]));
    const locationMap = Object.fromEntries(locations.map(l => [l.name.toLowerCase(), l.id]));

    for (let i = 0; i < rows.length; i++) {
      const row = rows[i];
      const errors = [];

      if (!row.product_name || !productMap[row.product_name.toLowerCase()]) {
        errors.push(`Produk "${row.product_name}" tidak ditemukan`);
      }
      if (!row.color_name || !colorMap[row.color_name.toLowerCase()]) {
        errors.push(`Warna "${row.color_name}" tidak ditemukan`);
      }
      if (!row.size_name || !sizeMap[row.size_name.toLowerCase()]) {
        errors.push(`Ukuran "${row.size_name}" tidak ditemukan`);
      }
      if (!row.location_name || !locationMap[row.location_name.toLowerCase()]) {
        errors.push(`Lokasi "${row.location_name}" tidak ditemukan`);
      }
      if (!row.quantity || isNaN(parseInt(row.quantity)) || parseInt(row.quantity) < 0) {
        errors.push('Quantity harus berupa angka positif');
      }

      validationResults.push({
        row: i + 1,
        data: row,
        valid: errors.length === 0,
        errors
      });
    }

    const validCount = validationResults.filter(r => r.valid).length;
    const invalidCount = validationResults.filter(r => !r.valid).length;

    res.json({
      success: true,
      data: {
        total: rows.length,
        valid: validCount,
        invalid: invalidCount,
        results: validationResults
      }
    });
  } catch (error) {
    console.error('Error validating import:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.post('/import-csv', async (req, res) => {
  const connection = await db.getConnection();

  try {
    const { rows, mode = 'add' } = req.body;

    if (!rows || !Array.isArray(rows) || rows.length === 0) {
      return res.status(400).json({ success: false, error: 'No data provided' });
    }

    await connection.beginTransaction();

    const [products] = await connection.query('SELECT id, name FROM products');
    const [colors] = await connection.query('SELECT id, name FROM colors');
    const [sizes] = await connection.query('SELECT id, name FROM sizes');
    const [locations] = await connection.query('SELECT id, name FROM locations');

    const productMap = Object.fromEntries(products.map(p => [p.name.toLowerCase(), p.id]));
    const colorMap = Object.fromEntries(colors.map(c => [c.name.toLowerCase(), c.id]));
    const sizeMap = Object.fromEntries(sizes.map(s => [s.name.toLowerCase(), s.id]));
    const locationMap = Object.fromEntries(locations.map(l => [l.name.toLowerCase(), l.id]));

    let successCount = 0;
    let errorCount = 0;
    const errors = [];

    for (const row of rows) {
      try {
        const productId = productMap[row.product_name.toLowerCase()];
        const colorId = colorMap[row.color_name.toLowerCase()];
        const sizeId = sizeMap[row.size_name.toLowerCase()];
        const locationId = locationMap[row.location_name.toLowerCase()];
        const quantity = parseInt(row.quantity);
        const unitCost = parseFloat(row.unit_cost) || 0;

        if (!productId || !colorId || !sizeId || !locationId) {
          errorCount++;
          continue;
        }

        const [[productColor]] = await connection.query(
          'SELECT id FROM product_colors WHERE product_id = ? AND color_id = ?',
          [productId, colorId]
        );

        if (!productColor) {
          errorCount++;
          errors.push(`Kombinasi produk-warna tidak ditemukan: ${row.product_name} - ${row.color_name}`);
          continue;
        }

        const [[variant]] = await connection.query(
          'SELECT id FROM product_color_sizes WHERE product_color_id = ? AND size_id = ?',
          [productColor.id, sizeId]
        );

        if (!variant) {
          errorCount++;
          errors.push(`Varian tidak ditemukan: ${row.product_name} - ${row.color_name} - ${row.size_name}`);
          continue;
        }

        if (mode === 'replace') {
          await connection.query(
            `INSERT INTO stock_balances (product_color_size_id, location_id, quantity, moving_avg_cost)
             VALUES (?, ?, ?, ?)
             ON DUPLICATE KEY UPDATE quantity = ?, moving_avg_cost = ?`,
            [variant.id, locationId, quantity, unitCost, quantity, unitCost]
          );
        } else {
          await connection.query(
            `INSERT INTO stock_balances (product_color_size_id, location_id, quantity, moving_avg_cost)
             VALUES (?, ?, ?, ?)
             ON DUPLICATE KEY UPDATE quantity = quantity + ?, moving_avg_cost = ?`,
            [variant.id, locationId, quantity, unitCost, quantity, unitCost]
          );
        }

        await connection.query(
          `INSERT INTO stock_movements (product_color_size_id, location_id, movement_type, quantity, unit_cost, reason, reference_type, movement_date)
           VALUES (?, ?, 'IN', ?, ?, 'CSV Import', 'IMPORT', CURDATE())`,
          [variant.id, locationId, quantity, unitCost]
        );

        successCount++;
      } catch (err) {
        errorCount++;
        errors.push(err.message);
      }
    }

    await connection.commit();

    res.json({
      success: true,
      data: {
        imported: successCount,
        failed: errorCount,
        errors: errors.slice(0, 10)
      }
    });
  } catch (error) {
    await connection.rollback();
    console.error('Error importing CSV:', error);
    res.status(500).json({ success: false, error: error.message });
  } finally {
    connection.release();
  }
});

export default router;

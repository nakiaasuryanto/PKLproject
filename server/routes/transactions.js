import express from 'express';
import db from '../db.js';

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const { start_date, end_date, type, customer_id, limit = 100 } = req.query;

    let query = `
      SELECT
        t.*,
        c.name as customer_name
      FROM transactions t
      LEFT JOIN customers c ON t.customer_id = c.id
      WHERE 1=1
    `;

    const params = [];

    if (start_date) {
      query += ' AND t.transaction_date >= ?';
      params.push(start_date);
    }

    if (end_date) {
      query += ' AND t.transaction_date <= ?';
      params.push(end_date);
    }

    if (type) {
      query += ' AND t.transaction_type = ?';
      params.push(type);
    }

    if (customer_id) {
      query += ' AND t.customer_id = ?';
      params.push(customer_id);
    }

    query += ' ORDER BY t.transaction_date DESC, t.created_at DESC LIMIT ?';
    params.push(parseInt(limit));

    const [transactions] = await db.query(query, params);

    transactions.forEach(t => {
      if (t.items) {
        if (typeof t.items === 'string') {
          try {
            t.items = JSON.parse(t.items);
          } catch (e) {
            t.items = [];
          }
        }
        // If already parsed (object/array), keep as is
      } else {
        t.items = [];
      }
    });

    res.json({ success: true, data: transactions });
  } catch (error) {
    console.error('Error fetching transactions:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const [transactions] = await db.query(`
      SELECT t.*, c.name as customer_name, c.phone as customer_phone, c.address as customer_address
      FROM transactions t
      LEFT JOIN customers c ON t.customer_id = c.id
      WHERE t.id = ?
    `, [id]);

    if (transactions.length === 0) {
      return res.status(404).json({ success: false, error: 'Transaction not found' });
    }

    const transaction = transactions[0];
    // Handle items - could be string, object, or null
    if (transaction.items) {
      if (typeof transaction.items === 'string') {
        try {
          transaction.items = JSON.parse(transaction.items);
        } catch (e) {
          transaction.items = [];
        }
      }
      // If already an array/object, keep as is
    } else {
      transaction.items = [];
    }

    res.json({ success: true, data: transaction });
  } catch (error) {
    console.error('Error fetching transaction:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.post('/', async (req, res) => {
  const connection = await db.getConnection();

  try {
    await connection.beginTransaction();

    const {
      transaction_type,
      transaction_date,
      customer_id,
      total_amount,
      payment_method,
      pic,
      notes,
      items,
      location_id = 1
    } = req.body;

    const locId = parseInt(location_id) || 1;

    const [result] = await connection.query(
      `INSERT INTO transactions
       (transaction_type, transaction_date, customer_id, total_amount, payment_method, pic, notes, items)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [transaction_type, transaction_date, customer_id, total_amount, payment_method, pic, notes, JSON.stringify(items || [])]
    );

    const transactionId = result.insertId;

    if ((transaction_type === 'SALE' || transaction_type === 'GIFT') && items) {
      const reason_code = transaction_type === 'SALE' ? 'SALES_OUT' : 'GIFT_OUT';

      for (const item of items) {
        if (item.quantity > 0) {
          await connection.query(
            `INSERT INTO stock_movements
             (product_color_size_id, location_id, movement_type, quantity, reason_code, reference_type, reference_id, movement_date, created_by)
             VALUES (?, ?, 'OUT', ?, ?, 'TRANSACTION', ?, ?, ?)`,
            [item.product_color_size_id, locId, item.quantity, reason_code, transactionId, transaction_date, pic]
          );

          await connection.query(
            `UPDATE stock_balances
             SET quantity = quantity - ?
             WHERE product_color_size_id = ? AND location_id = ?`,
            [item.quantity, item.product_color_size_id, locId]
          );
        }
      }
    }

    if (customer_id && transaction_type === 'SALE') {
      await connection.query(
        `UPDATE customers
         SET total_purchases = total_purchases + 1,
             total_spent = total_spent + ?,
             last_purchase_date = ?
         WHERE id = ?`,
        [total_amount, transaction_date, customer_id]
      );
    }

    await connection.commit();

    res.status(201).json({
      success: true,
      data: { id: transactionId }
    });
  } catch (error) {
    await connection.rollback();
    console.error('Error creating transaction:', error);
    res.status(500).json({ success: false, error: error.message });
  } finally {
    connection.release();
  }
});

router.post('/create', async (req, res) => {
  const connection = await db.getConnection();

  try {
    await connection.beginTransaction();

    const {
      type,
      date,
      payment_method,
      promo_type,
      pic_sales,
      customer_name,
      customer_phone,
      manual_price,
      items,
      total,
      expense_category,
      description,
      amount,
      pic,
      location_id = 1
    } = req.body;

    const locationId = parseInt(location_id) || 1;

    const transaction_type = type === 'penjualan' ? 'SALE' : type === 'pengeluaran' ? 'EXPENSE' : 'SALE';
    const transaction_date = date || new Date().toISOString().split('T')[0];

    let customer_id = null;
    if (transaction_type === 'SALE' && customer_phone) {
      const [customers] = await connection.query(
        'SELECT id FROM customers WHERE phone = ? LIMIT 1',
        [customer_phone]
      );
      if (customers.length > 0) {
        customer_id = customers[0].id;
      }
    }

    let total_amount = 0;
    if (transaction_type === 'EXPENSE') {
      total_amount = amount || 0;
    } else if (manual_price && manual_price > 0) {
      total_amount = manual_price;
    } else if (total) {
      total_amount = total;
    } else if (items && items.length > 0) {
      total_amount = items.reduce((sum, item) => sum + (item.quantity * item.price), 0);
    }

    let notes = '';
    if (transaction_type === 'EXPENSE') {
      notes = `${expense_category || ''}: ${description || ''}`;
    } else {
      notes = promo_type ? `Promo: ${promo_type}` : '';
    }

    // Default to PENDING for sales, will be PAID when VA is paid
    const initialPaymentStatus = transaction_type === 'EXPENSE' ? 'PAID' : 'PENDING';

    const [result] = await connection.query(
      `INSERT INTO transactions
       (transaction_type, transaction_date, customer_id, total_amount, payment_method, pic, notes, items, payment_status)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        transaction_type,
        transaction_date,
        customer_id,
        total_amount,
        payment_method || 'VA', // Default to VA for sales
        pic_sales || pic || null,
        notes,
        JSON.stringify(items || []),
        initialPaymentStatus
      ]
    );

    const transactionId = result.insertId;

    // Auto-generate VA for sales transactions
    let vaNumber = null;
    let prospectingId = null;
    if (transaction_type === 'SALE' && total_amount > 0) {
      try {
        // Find prospecting by phone number in kontaks
        if (customer_phone) {
          const [prospectings] = await connection.query(
            `SELECT p.id FROM prospectings p
             JOIN kontaks k ON p.kontak_id = k.id
             WHERE k.telepon = ? AND p.status != 'Closed'
             ORDER BY p.id DESC LIMIT 1`,
            [customer_phone]
          );
          if (prospectings.length > 0) {
            prospectingId = prospectings[0].id;
          }
        }

        // Fallback: try by customer name in kontaks
        if (!prospectingId && customer_name) {
          const [prospectings] = await connection.query(
            `SELECT p.id FROM prospectings p
             JOIN kontaks k ON p.kontak_id = k.id
             WHERE k.nama = ? AND p.status != 'Closed'
             ORDER BY p.id DESC LIMIT 1`,
            [customer_name]
          );
          if (prospectings.length > 0) {
            prospectingId = prospectings[0].id;
          }
        }

        // Generate VA number (format: 88810 + 13 digit)
        const timestamp = Date.now().toString().slice(-10);
        const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
        vaNumber = `88810${timestamp}${random}`;

        // Insert VA record
        await connection.query(
          `INSERT INTO virtual_accounts
           (prospecting_id, transaction_id, va_number, customer_no, customer_name, amount, status, expired_at)
           VALUES (?, ?, ?, ?, ?, ?, 'ACTIVE', DATE_ADD(NOW(), INTERVAL 24 HOUR))`,
          [
            prospectingId,
            transactionId,
            vaNumber,
            customer_phone || '',
            customer_name || '',
            total_amount
          ]
        );

        // Update prospecting status to Closing if linked
        if (prospectingId) {
          await connection.query(
            `UPDATE prospectings SET status = 'Closing', omzet = ? WHERE id = ?`,
            [total_amount, prospectingId]
          );
        }
      } catch (vaErr) {
        console.log('[Transaction] VA generation skipped:', vaErr.message);
      }
    }

    if (transaction_type === 'SALE' && items && items.length > 0) {
      for (const item of items) {
        let pcsId = item.product_color_size_id ? parseInt(item.product_color_size_id) : null;

        if (!pcsId && item.name) {
          const [found] = await connection.query(`
            SELECT pcs.id
            FROM product_color_sizes pcs
            JOIN product_colors pc ON pcs.product_color_id = pc.id
            JOIN products p ON pc.product_id = p.id
            JOIN colors c ON pc.color_id = c.id
            JOIN sizes s ON pcs.size_id = s.id
            WHERE p.name LIKE ?
              AND (c.name LIKE ? OR ? IS NULL OR ? = '')
              AND (s.name LIKE ? OR ? IS NULL OR ? = '')
            LIMIT 1
          `, [
            `%${item.name}%`,
            `%${item.color || ''}%`,
            item.color,
            item.color,
            `%${item.size || ''}%`,
            item.size,
            item.size
          ]);

          if (found.length > 0) {
            pcsId = found[0].id;
          }
        }

        if (pcsId && item.quantity > 0) {
          await connection.query(
            `INSERT INTO stock_movements
             (product_color_size_id, location_id, movement_type, quantity, reason_code, reference_type, reference_id, movement_date, created_by)
             VALUES (?, ?, 'OUT', ?, 'SALES_OUT', 'TRANSACTION', ?, ?, ?)`,
            [pcsId, locationId, item.quantity, transactionId, transaction_date, pic_sales || 'System']
          );

          await connection.query(
            `UPDATE stock_balances
             SET quantity = quantity - ?
             WHERE product_color_size_id = ? AND location_id = ?`,
            [item.quantity, pcsId, locationId]
          );
        }
      }

      if (customer_id) {
        await connection.query(
          `UPDATE customers
           SET total_purchases = total_purchases + 1,
               total_spent = total_spent + ?,
               last_purchase_date = ?
           WHERE id = ?`,
          [total_amount, transaction_date, customer_id]
        );
      }
    }

    await connection.commit();

    res.status(201).json({
      success: true,
      data: {
        id: transactionId,
        va_number: vaNumber,
        payment_status: initialPaymentStatus,
        message: vaNumber ? `Invoice created with VA: ${vaNumber}` : 'Invoice created'
      }
    });
  } catch (error) {
    await connection.rollback();
    console.error('Error creating transaction:', error);
    res.status(500).json({ success: false, error: error.message });
  } finally {
    connection.release();
  }
});

/**
 * Toggle payment status (PENDING <-> PAID)
 * When marking as PAID, also creates journal entry
 */
router.patch('/:id/toggle-paid', async (req, res) => {
  const connection = await db.getConnection();

  try {
    await connection.beginTransaction();

    const { id } = req.params;

    // Get current transaction
    const [transactions] = await connection.query(
      'SELECT * FROM transactions WHERE id = ?',
      [id]
    );

    if (transactions.length === 0) {
      await connection.rollback();
      return res.status(404).json({ success: false, error: 'Transaction not found' });
    }

    const transaction = transactions[0];
    const newStatus = transaction.payment_status === 'PAID' ? 'PENDING' : 'PAID';
    const paidAt = newStatus === 'PAID' ? new Date() : null;

    // Update transaction status
    await connection.query(
      'UPDATE transactions SET payment_status = ?, paid_at = ? WHERE id = ?',
      [newStatus, paidAt, id]
    );

    // If marking as PAID, create journal entry and update related records
    if (newStatus === 'PAID') {
      // Update VA status if exists
      await connection.query(
        `UPDATE virtual_accounts SET status = 'PAID', paid_at = NOW() WHERE transaction_id = ?`,
        [id]
      );

      // Update prospecting status to Closed
      const [vas] = await connection.query(
        'SELECT prospecting_id FROM virtual_accounts WHERE transaction_id = ?',
        [id]
      );
      if (vas.length > 0 && vas[0].prospecting_id) {
        await connection.query(
          `UPDATE prospectings SET status = 'Closed' WHERE id = ?`,
          [vas[0].prospecting_id]
        );
      }

      // Create journal entry
      const journalDate = new Date().toISOString().split('T')[0];
      const journalRef = `INV-${id}`;

      // Check if journal_entries table exists and create entry
      try {
        // Debit: Kas/Bank (increase)
        // Credit: Pendapatan Penjualan (increase)
        await connection.query(
          `INSERT INTO journal_entries
           (entry_date, reference_number, description, account_code, account_name, debit, credit, transaction_id)
           VALUES
           (?, ?, ?, '1101', 'Kas', ?, 0, ?),
           (?, ?, ?, '4101', 'Pendapatan Penjualan', 0, ?, ?)`,
          [
            journalDate, journalRef, `Pembayaran invoice #${id}`, transaction.total_amount, id,
            journalDate, journalRef, `Pembayaran invoice #${id}`, transaction.total_amount, id
          ]
        );
      } catch (journalErr) {
        // Journal table might not exist, log and continue
        console.log('[Transaction] Journal entry skipped:', journalErr.message);
      }
    } else {
      // If marking as PENDING (unpaid), revert VA status
      await connection.query(
        `UPDATE virtual_accounts SET status = 'ACTIVE', paid_at = NULL WHERE transaction_id = ?`,
        [id]
      );

      // Revert prospecting status to Closing
      const [vas] = await connection.query(
        'SELECT prospecting_id FROM virtual_accounts WHERE transaction_id = ?',
        [id]
      );
      if (vas.length > 0 && vas[0].prospecting_id) {
        await connection.query(
          `UPDATE prospectings SET status = 'Closing' WHERE id = ?`,
          [vas[0].prospecting_id]
        );
      }
    }

    await connection.commit();

    res.json({
      success: true,
      data: {
        id: parseInt(id),
        payment_status: newStatus,
        message: newStatus === 'PAID' ? 'Invoice marked as paid, journal created' : 'Invoice marked as unpaid'
      }
    });
  } catch (error) {
    await connection.rollback();
    console.error('Error toggling payment status:', error);
    res.status(500).json({ success: false, error: error.message });
  } finally {
    connection.release();
  }
});

router.get('/stats/summary', async (req, res) => {
  try {
    const { start_date, end_date } = req.query;

    let query = `
      SELECT
        transaction_type,
        COUNT(*) as count,
        SUM(total_amount) as total
      FROM transactions
      WHERE 1=1
    `;

    const params = [];

    if (start_date) {
      query += ' AND transaction_date >= ?';
      params.push(start_date);
    }

    if (end_date) {
      query += ' AND transaction_date <= ?';
      params.push(end_date);
    }

    query += ' GROUP BY transaction_type';

    const [stats] = await db.query(query, params);

    res.json({ success: true, data: stats });
  } catch (error) {
    console.error('Error fetching stats:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

export default router;

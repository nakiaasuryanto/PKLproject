import express from 'express';
import db from '../db.js';

const router = express.Router();

// GET /api/transactions - Get all transactions
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

    // Parse JSON items
    transactions.forEach(t => {
      if (t.items) {
        try {
          t.items = JSON.parse(t.items);
        } catch (e) {
          t.items = [];
        }
      }
    });

    res.json({ success: true, data: transactions });
  } catch (error) {
    console.error('Error fetching transactions:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// GET /api/transactions/:id - Get transaction details
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const [transactions] = await db.query(`
      SELECT t.*, c.name as customer_name
      FROM transactions t
      LEFT JOIN customers c ON t.customer_id = c.id
      WHERE t.id = ?
    `, [id]);

    if (transactions.length === 0) {
      return res.status(404).json({ success: false, error: 'Transaction not found' });
    }

    const transaction = transactions[0];
    if (transaction.items) {
      try {
        transaction.items = JSON.parse(transaction.items);
      } catch (e) {
        transaction.items = [];
      }
    }

    res.json({ success: true, data: transaction });
  } catch (error) {
    console.error('Error fetching transaction:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// POST /api/transactions - Create transaction
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
      items // [{product_color_size_id, quantity, price, free}]
    } = req.body;

    // Insert transaction
    const [result] = await connection.query(
      `INSERT INTO transactions
       (transaction_type, transaction_date, customer_id, total_amount, payment_method, pic, notes, items)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [transaction_type, transaction_date, customer_id, total_amount, payment_method, pic, notes, JSON.stringify(items || [])]
    );

    const transactionId = result.insertId;

    // If SALE or GIFT, create stock movements
    if ((transaction_type === 'SALE' || transaction_type === 'GIFT') && items) {
      const reason_code = transaction_type === 'SALE' ? 'SALES_OUT' : 'GIFT_OUT';

      for (const item of items) {
        if (item.quantity > 0) {
          // Create stock movement (assuming default location)
          await connection.query(
            `INSERT INTO stock_movements
             (product_color_size_id, location_id, movement_type, quantity, reason_code, reference_type, reference_id, movement_date, created_by)
             VALUES (?, 1, 'OUT', ?, ?, 'TRANSACTION', ?, ?, ?)`,
            [item.product_color_size_id, item.quantity, reason_code, transactionId, transaction_date, pic]
          );

          // Update stock balance
          await connection.query(
            `UPDATE stock_balances
             SET quantity = quantity - ?
             WHERE product_color_size_id = ? AND location_id = 1`,
            [item.quantity, item.product_color_size_id]
          );
        }
      }
    }

    // Update customer stats if customer_id provided
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

// POST /api/transactions/create - Create transaction from frontend form
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
      // For expense transactions
      expense_category,
      description,
      amount,
      pic
    } = req.body;

    // Determine transaction type
    const transaction_type = type === 'penjualan' ? 'SALE' : type === 'pengeluaran' ? 'EXPENSE' : 'SALE';
    const transaction_date = date || new Date().toISOString().split('T')[0];

    // For sales: find or use customer
    let customer_id = null;
    if (transaction_type === 'SALE' && customer_phone) {
      // Try to find customer by phone
      const [customers] = await connection.query(
        'SELECT id FROM customers WHERE phone = ? LIMIT 1',
        [customer_phone]
      );
      if (customers.length > 0) {
        customer_id = customers[0].id;
      }
    }

    // Calculate total amount
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

    // Build notes
    let notes = '';
    if (transaction_type === 'EXPENSE') {
      notes = `${expense_category || ''}: ${description || ''}`;
    } else {
      notes = promo_type ? `Promo: ${promo_type}` : '';
    }

    // Insert transaction
    const [result] = await connection.query(
      `INSERT INTO transactions
       (transaction_type, transaction_date, customer_id, total_amount, payment_method, pic, notes, items, payment_status)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        transaction_type,
        transaction_date,
        customer_id,
        total_amount,
        payment_method || 'CASH',
        pic_sales || pic || null,
        notes,
        JSON.stringify(items || []),
        'PAID'
      ]
    );

    const transactionId = result.insertId;

    // For SALE: process stock movements if items have product_color_size_id
    if (transaction_type === 'SALE' && items && items.length > 0) {
      for (const item of items) {
        let pcsId = item.product_color_size_id ? parseInt(item.product_color_size_id) : null;

        // If no direct ID, try to find by product name, color, size
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

        // If we found a product_color_size_id, update stock
        if (pcsId && item.quantity > 0) {
          // Create stock movement
          await connection.query(
            `INSERT INTO stock_movements
             (product_color_size_id, location_id, movement_type, quantity, reason_code, reference_type, reference_id, movement_date, created_by)
             VALUES (?, 1, 'OUT', ?, 'SALES_OUT', 'TRANSACTION', ?, ?, ?)`,
            [pcsId, item.quantity, transactionId, transaction_date, pic_sales || 'System']
          );

          // Update stock balance
          await connection.query(
            `UPDATE stock_balances
             SET quantity = quantity - ?
             WHERE product_color_size_id = ? AND location_id = 1`,
            [item.quantity, pcsId]
          );
        }
      }

      // Update customer stats if customer found
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

// GET /api/transactions/stats - Transaction statistics
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

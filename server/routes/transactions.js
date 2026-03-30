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

import express from 'express';
import db from '../db.js';

const router = express.Router();

// GET /api/inventory/stock - Get stock levels
router.get('/stock', async (req, res) => {
  try {
    const { location_id, low_stock } = req.query;

    let query = `
      SELECT
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

// GET /api/inventory/movements - Get stock movements
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

// POST /api/inventory/movements - Create stock movement
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

    // Update stock balance
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

// GET /api/inventory/locations - Get all locations
router.get('/locations', async (req, res) => {
  try {
    const [locations] = await db.query('SELECT * FROM locations ORDER BY name');
    res.json({ success: true, data: locations });
  } catch (error) {
    console.error('Error fetching locations:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

export default router;

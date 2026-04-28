import express from 'express';
import db from '../db.js';

const router = express.Router();

// GET /api/customers - Get all customers
router.get('/', async (req, res) => {
  try {
    const { status, city, type, search } = req.query;

    let query = 'SELECT * FROM customers WHERE 1=1';
    const params = [];

    if (status) {
      query += ' AND status = ?';
      params.push(status);
    }

    if (city) {
      query += ' AND city = ?';
      params.push(city);
    }

    if (type) {
      query += ' AND customer_type = ?';
      params.push(type);
    }

    if (search) {
      query += ' AND (name LIKE ? OR customer_code LIKE ? OR email LIKE ?)';
      const searchTerm = `%${search}%`;
      params.push(searchTerm, searchTerm, searchTerm);
    }

    query += ' ORDER BY total_spent DESC';

    const [customers] = await db.query(query, params);

    res.json({ success: true, data: customers });
  } catch (error) {
    console.error('Error fetching customers:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// GET /api/customers/:id - Get customer with interactions
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const [customers] = await db.query('SELECT * FROM customers WHERE id = ?', [id]);
    if (customers.length === 0) {
      return res.status(404).json({ success: false, error: 'Customer not found' });
    }

    const [interactions] = await db.query(
      'SELECT * FROM customer_interactions WHERE customer_id = ? ORDER BY interaction_date DESC',
      [id]
    );

    res.json({
      success: true,
      data: {
        ...customers[0],
        interactions
      }
    });
  } catch (error) {
    console.error('Error fetching customer:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// POST /api/customers - Create customer
router.post('/', async (req, res) => {
  try {
    const { customer_code, name, company_name, email, phone, address, city, customer_type } = req.body;

    // Auto-generate customer_code if not provided
    let finalCustomerCode = customer_code;
    if (!finalCustomerCode) {
      // Get last customer code
      const [lastCustomer] = await db.query(
        'SELECT customer_code FROM customers ORDER BY id DESC LIMIT 1'
      );

      if (lastCustomer.length === 0) {
        finalCustomerCode = 'CUST001';
      } else {
        const lastCode = lastCustomer[0].customer_code;
        const lastNumber = parseInt(lastCode.replace('CUST', ''));
        finalCustomerCode = `CUST${String(lastNumber + 1).padStart(3, '0')}`;
      }
    }

    const [result] = await db.query(
      `INSERT INTO customers (customer_code, name, company_name, email, phone, address, city, customer_type)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [finalCustomerCode, name, company_name, email, phone, address, city, customer_type]
    );

    res.status(201).json({
      success: true,
      data: { id: result.insertId, customer_code: finalCustomerCode }
    });
  } catch (error) {
    console.error('Error creating customer:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// PUT /api/customers/:id - Update customer
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, company_name, email, phone, address, city, customer_type, status } = req.body;

    await db.query(
      `UPDATE customers
       SET name = ?, company_name = ?, email = ?, phone = ?, address = ?, city = ?, customer_type = ?, status = ?
       WHERE id = ?`,
      [name, company_name, email, phone, address, city, customer_type, status, id]
    );

    res.json({ success: true, data: { id, ...req.body } });
  } catch (error) {
    console.error('Error updating customer:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// POST /api/customers/:id/interactions - Add interaction
router.post('/:id/interactions', async (req, res) => {
  try {
    const { id } = req.params;
    const { interaction_type, subject, description, pic, interaction_date } = req.body;

    const [result] = await db.query(
      `INSERT INTO customer_interactions
       (customer_id, interaction_type, subject, description, interaction_date, pic)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [id, interaction_type, subject, description, interaction_date || new Date(), pic]
    );

    res.status(201).json({
      success: true,
      data: { id: result.insertId }
    });
  } catch (error) {
    console.error('Error creating interaction:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// GET /api/customers/stats/summary - CRM statistics
router.get('/stats/summary', async (req, res) => {
  try {
    const [stats] = await db.query(`
      SELECT
        COUNT(*) as total_customers,
        SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active_customers,
        SUM(total_purchases) as total_orders,
        SUM(total_spent) as total_revenue
      FROM customers
    `);

    res.json({ success: true, data: stats[0] });
  } catch (error) {
    console.error('Error fetching customer stats:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

export default router;

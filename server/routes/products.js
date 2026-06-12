import express from 'express';
import db from '../db.js';

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const [products] = await db.query(`
      SELECT
        p.*,
        (SELECT COUNT(*) FROM product_colors pc WHERE pc.product_id = p.id) as color_count
      FROM products p
      WHERE p.status = 'active'
      ORDER BY p.name
    `);

    res.json({ success: true, data: products });
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const [products] = await db.query('SELECT * FROM products WHERE id = ?', [id]);
    if (products.length === 0) {
      return res.status(404).json({ success: false, error: 'Product not found' });
    }

    const [colors] = await db.query(`
      SELECT pc.*, c.name as color_name, c.hex_code
      FROM product_colors pc
      JOIN colors c ON pc.color_id = c.id
      WHERE pc.product_id = ?
    `, [id]);

    for (let color of colors) {
      const [sizes] = await db.query(`
        SELECT pcs.*, s.name as size_name, s.sort_order
        FROM product_color_sizes pcs
        JOIN sizes s ON pcs.size_id = s.id
        WHERE pcs.product_color_id = ?
        ORDER BY s.sort_order
      `, [color.id]);
      color.sizes = sizes;
    }

    res.json({
      success: true,
      data: {
        ...products[0],
        colors
      }
    });
  } catch (error) {
    console.error('Error fetching product:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.post('/', async (req, res) => {
  try {
    const { name, code, category, description, base_price, retail_price } = req.body;

    const [result] = await db.query(
      'INSERT INTO products (name, code, category, description, base_price, retail_price) VALUES (?, ?, ?, ?, ?, ?)',
      [name, code, category, description, base_price, retail_price]
    );

    res.status(201).json({
      success: true,
      data: { id: result.insertId, ...req.body }
    });
  } catch (error) {
    console.error('Error creating product:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, code, category, description, base_price, retail_price, status } = req.body;

    await db.query(
      `UPDATE products
       SET name = ?, code = ?, category = ?, description = ?, base_price = ?, retail_price = ?, status = ?
       WHERE id = ?`,
      [name, code, category, description, base_price, retail_price, status, id]
    );

    res.json({ success: true, data: { id, ...req.body } });
  } catch (error) {
    console.error('Error updating product:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    await db.query('UPDATE products SET status = ? WHERE id = ?', ['inactive', id]);

    res.json({ success: true, message: 'Product deleted' });
  } catch (error) {
    console.error('Error deleting product:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

export default router;

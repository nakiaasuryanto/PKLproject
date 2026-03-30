const mysql = require('mysql2/promise');

async function test() {
  const pool = mysql.createPool({
    host: '127.0.0.1',
    port: 3306,
    user: 'u705828172_pklproject',
    password: 'Bismillah9',
    database: 'u705828172_pklproject',
  });

  const sql = `
    SELECT DISTINCT
      p.id,
      p.code,
      p.name,
      p.category,
      p.base_price,
      p.retail_price,
      p.status,
      COUNT(DISTINCT pcs.id) as variant_count
    FROM products p
    LEFT JOIN product_colors pc ON p.id = pc.product_id
    LEFT JOIN product_color_sizes pcs ON pc.id = pcs.product_color_id
    GROUP BY p.id
    ORDER BY p.created_at DESC
    LIMIT ? OFFSET ?
  `;

  try {
    console.log('Testing with params:', [20, 0]);
    const [results] = await pool.execute(sql, [20, 0]);
    console.log('Success! Rows:', results.length);
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await pool.end();
  }
}

test();

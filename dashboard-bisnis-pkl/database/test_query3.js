const mysql = require('mysql2/promise');

async function test() {
  const pool = mysql.createPool({
    host: '127.0.0.1',
    port: 3306,
    user: 'u705828172_pklproject',
    password: 'Bismillah9',
    database: 'u705828172_pklproject',
  });

  // Try with query() instead of execute()
  const sql = `
    SELECT DISTINCT
      p.id,
      p.code,
      p.name,
      p.category
    FROM products p
    LIMIT ?
  `;

  try {
    console.log('Test with pool.query() instead of pool.execute()');
    const [results] = await pool.query(sql, [20]);
    console.log('Success! Rows:', results.length);
  } catch (error) {
    console.error('Error:', error.message);
  }

  await pool.end();
}

test();

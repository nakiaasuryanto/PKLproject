const mysql = require('mysql2/promise');

async function test() {
  const pool = mysql.createPool({
    host: '127.0.0.1',
    port: 3306,
    user: 'u705828172_pklproject',
    password: 'Bismillah9',
    database: 'u705828172_pklproject',
  });

  // Test without LIMIT/OFFSET first
  const sql1 = `
    SELECT DISTINCT
      p.id,
      p.code,
      p.name,
      p.category
    FROM products p
    LIMIT 20
  `;

  try {
    console.log('Test 1: Simple query without params');
    const [results1] = await pool.execute(sql1);
    console.log('Success! Rows:', results1.length);
  } catch (error) {
    console.error('Error:', error.message);
  }

  // Test with LIMIT param only
  const sql2 = `
    SELECT DISTINCT
      p.id,
      p.code,
      p.name,
      p.category
    FROM products p
    LIMIT ?
  `;

  try {
    console.log('\nTest 2: Query with LIMIT param');
    const [results2] = await pool.execute(sql2, [20]);
    console.log('Success! Rows:', results2.length);
  } catch (error) {
    console.error('Error:', error.message);
  }

  await pool.end();
}

test();

import mysql from 'mysql2';
import dotenv from 'dotenv';

dotenv.config();

// Create connection pool
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Promisify for async/await
const promisePool = pool.promise();

// Test connection
pool.getConnection((err, connection) => {
  if (err) {
    console.error('Database connection failed:', err.message);
    console.log('Retrying connection in 5 seconds...');
    setTimeout(() => {
      pool.getConnection((retryErr, retryConn) => {
        if (retryErr) {
          console.error('Database connection retry failed:', retryErr.message);
          console.log('Continuing without database connection...');
          return;
        }
        console.log('Database connected successfully (retry)');
        retryConn.release();
      });
    }, 5000);
    return;
  }
  console.log('Database connected successfully');
  connection.release();
});

export default promisePool;

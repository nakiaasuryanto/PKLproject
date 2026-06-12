import mysql from 'mysql2';
import dotenv from 'dotenv';

dotenv.config();

const dbConfig = {
  host: process.env.MYSQLHOST || process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.MYSQLPORT || process.env.DB_PORT || '3306'),
  user: process.env.MYSQLUSER || process.env.DB_USER,
  password: process.env.MYSQLPASSWORD || process.env.DB_PASSWORD,
  database: process.env.MYSQLDATABASE || process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

const pool = mysql.createPool(dbConfig);

const promisePool = pool.promise();

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

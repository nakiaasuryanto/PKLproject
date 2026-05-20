import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import pool from './db.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const MIGRATIONS_DIR = path.join(__dirname, 'migrations');

// Create migrations tracking table
async function createMigrationsTable() {
  const sql = `
    CREATE TABLE IF NOT EXISTS _migrations (
      id INT PRIMARY KEY AUTO_INCREMENT,
      filename VARCHAR(255) NOT NULL UNIQUE,
      executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `;
  await pool.query(sql);
}

// Get list of executed migrations
async function getExecutedMigrations() {
  try {
    const [rows] = await pool.query('SELECT filename FROM _migrations ORDER BY filename');
    return rows.map(row => row.filename);
  } catch (error) {
    // Table might not exist yet
    return [];
  }
}

// Get all migration files sorted by name
function getMigrationFiles() {
  if (!fs.existsSync(MIGRATIONS_DIR)) {
    console.log('No migrations folder found');
    return [];
  }

  return fs.readdirSync(MIGRATIONS_DIR)
    .filter(file => file.endsWith('.sql'))
    .sort();
}

// Execute a single migration file
async function executeMigration(filename) {
  const filepath = path.join(MIGRATIONS_DIR, filename);
  const sql = fs.readFileSync(filepath, 'utf8');

  // Split by semicolon and filter empty statements
  const statements = sql
    .split(';')
    .map(s => s.trim())
    .filter(s => s.length > 0 && !s.startsWith('--'));

  for (const statement of statements) {
    if (statement.length > 0) {
      try {
        await pool.query(statement);
      } catch (err) {
        // Skip "already exists" errors (idempotent migrations)
        if (err.message.includes('already exists') ||
            err.message.includes('Duplicate column') ||
            err.message.includes('Duplicate key name') ||
            err.message.includes('Duplicate entry')) {
          console.log(`  ⚠️  Skipped (already exists)`);
        } else {
          throw err;
        }
      }
    }
  }

  // Record migration as executed
  await pool.query('INSERT INTO _migrations (filename) VALUES (?)', [filename]);
}

// Run all pending migrations
export async function runMigrations() {
  console.log('Starting database migration...');

  try {
    // Ensure migrations table exists
    await createMigrationsTable();

    const executed = await getExecutedMigrations();
    const files = getMigrationFiles();
    const pending = files.filter(f => !executed.includes(f));

    if (pending.length === 0) {
      console.log('Database is up to date. No migrations to run.');
      return { success: true, migrated: [] };
    }

    console.log(`Found ${pending.length} pending migration(s)`);

    const migrated = [];
    for (const file of pending) {
      console.log(`Running migration: ${file}`);
      await executeMigration(file);
      console.log(`Completed: ${file}`);
      migrated.push(file);
    }

    console.log(`Successfully ran ${migrated.length} migration(s)`);
    return { success: true, migrated };

  } catch (error) {
    console.error('Migration failed:', error.message);
    return { success: false, error: error.message };
  }
}

// Run if called directly
const isMainModule = process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1];
if (isMainModule) {
  runMigrations()
    .then(async result => {
      if (result.success) {
        console.log('Migration completed successfully');
      } else {
        console.error('Migration failed');
      }
      // Close pool connection
      await pool.end();
      process.exit(result.success ? 0 : 1);
    })
    .catch(async err => {
      console.error('Migration error:', err);
      await pool.end();
      process.exit(1);
    });
}

import express from 'express';
import bcrypt from 'bcrypt';
import { v4 as uuidv4 } from 'uuid';
import db from '../db.js';

const router = express.Router();

// Role permissions mapping
export const ROLE_PERMISSIONS = {
  admin: {
    modules: ['dashboard', 'sales', 'finance', 'crm', 'inventory', 'hr'],
    canViewSummary: true,
    canManageUsers: true
  },
  it: {
    modules: ['dashboard', 'sales', 'finance', 'crm', 'inventory', 'hr'],
    canViewSummary: false,
    canManageUsers: false
  },
  customer_service: {
    modules: ['crm', 'sales'],
    canViewSummary: false,
    canManageUsers: false
  },
  operations: {
    modules: ['inventory', 'sales'],
    canViewSummary: false,
    canManageUsers: false
  },
  finance: {
    modules: ['finance', 'sales'],
    canViewSummary: false,
    canManageUsers: false
  }
};

// POST /api/auth/login
router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({ success: false, error: 'Username dan password harus diisi' });
    }

    // Find user
    const [users] = await db.query(
      'SELECT * FROM users WHERE username = ? AND is_active = TRUE',
      [username]
    );

    if (users.length === 0) {
      return res.status(401).json({ success: false, error: 'Username atau password salah' });
    }

    const user = users[0];

    // Check password
    const validPassword = await bcrypt.compare(password, user.password_hash);
    if (!validPassword) {
      return res.status(401).json({ success: false, error: 'Username atau password salah' });
    }

    // Create session
    const sessionId = uuidv4();
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours

    await db.query(
      'INSERT INTO user_sessions (id, user_id, expires_at) VALUES (?, ?, ?)',
      [sessionId, user.id, expiresAt]
    );

    // Update last login
    await db.query('UPDATE users SET last_login = NOW() WHERE id = ?', [user.id]);

    // Get permissions
    const permissions = ROLE_PERMISSIONS[user.role] || ROLE_PERMISSIONS.operations;

    res.json({
      success: true,
      data: {
        sessionId,
        user: {
          id: user.id,
          username: user.username,
          name: user.name,
          email: user.email,
          role: user.role
        },
        permissions,
        expiresAt
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ success: false, error: 'Terjadi kesalahan saat login' });
  }
});

// POST /api/auth/logout
router.post('/logout', async (req, res) => {
  try {
    const sessionId = req.headers['x-session-id'];

    if (sessionId) {
      await db.query('DELETE FROM user_sessions WHERE id = ?', [sessionId]);
    }

    res.json({ success: true, message: 'Logout berhasil' });
  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({ success: false, error: 'Terjadi kesalahan saat logout' });
  }
});

// GET /api/auth/me - Get current user
router.get('/me', async (req, res) => {
  try {
    const sessionId = req.headers['x-session-id'];

    if (!sessionId) {
      return res.status(401).json({ success: false, error: 'Tidak terautentikasi' });
    }

    // Find valid session
    const [sessions] = await db.query(
      `SELECT s.*, u.id as user_id, u.username, u.name, u.email, u.role
       FROM user_sessions s
       JOIN users u ON s.user_id = u.id
       WHERE s.id = ? AND s.expires_at > NOW() AND u.is_active = TRUE`,
      [sessionId]
    );

    if (sessions.length === 0) {
      return res.status(401).json({ success: false, error: 'Session tidak valid atau expired' });
    }

    const session = sessions[0];
    const permissions = ROLE_PERMISSIONS[session.role] || ROLE_PERMISSIONS.operations;

    res.json({
      success: true,
      data: {
        user: {
          id: session.user_id,
          username: session.username,
          name: session.name,
          email: session.email,
          role: session.role
        },
        permissions
      }
    });
  } catch (error) {
    console.error('Get user error:', error);
    res.status(500).json({ success: false, error: 'Terjadi kesalahan' });
  }
});

// POST /api/auth/register - Create new user (admin only)
router.post('/register', async (req, res) => {
  try {
    const { username, password, name, email, role } = req.body;

    if (!username || !password || !name || !role) {
      return res.status(400).json({ success: false, error: 'Data tidak lengkap' });
    }

    // Check if username exists
    const [existing] = await db.query('SELECT id FROM users WHERE username = ?', [username]);
    if (existing.length > 0) {
      return res.status(400).json({ success: false, error: 'Username sudah digunakan' });
    }

    // Hash password
    const saltRounds = 10;
    const passwordHash = await bcrypt.hash(password, saltRounds);

    // Insert user
    const [result] = await db.query(
      'INSERT INTO users (username, password_hash, name, email, role) VALUES (?, ?, ?, ?, ?)',
      [username, passwordHash, name, email || null, role]
    );

    res.json({
      success: true,
      data: {
        id: result.insertId,
        username,
        name,
        email,
        role
      }
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ success: false, error: 'Terjadi kesalahan saat registrasi' });
  }
});

// GET /api/auth/users - Get all users (admin only)
router.get('/users', async (req, res) => {
  try {
    const [users] = await db.query(
      'SELECT id, username, name, email, role, is_active, last_login, created_at FROM users ORDER BY name'
    );

    res.json({ success: true, data: users });
  } catch (error) {
    console.error('Get users error:', error);
    res.status(500).json({ success: false, error: 'Terjadi kesalahan' });
  }
});

// POST /api/auth/setup - Create default users (run once)
router.post('/setup', async (req, res) => {
  try {
    // Check if users already exist
    const [existing] = await db.query('SELECT COUNT(*) as count FROM users');
    if (existing[0].count > 0) {
      return res.json({ success: true, message: 'Users already exist', skipped: true });
    }

    const saltRounds = 10;
    const defaultUsers = [
      { username: 'admin', password: 'admin123', name: 'Administrator', email: 'admin@dashboard.com', role: 'admin' },
      { username: 'it_staff', password: 'it123', name: 'IT Staff', email: 'it@dashboard.com', role: 'it' },
      { username: 'cs_staff', password: 'cs123', name: 'Customer Service', email: 'cs@dashboard.com', role: 'customer_service' },
      { username: 'ops_staff', password: 'ops123', name: 'Operations Staff', email: 'ops@dashboard.com', role: 'operations' },
      { username: 'finance_staff', password: 'finance123', name: 'Finance Staff', email: 'finance@dashboard.com', role: 'finance' }
    ];

    const created = [];
    for (const user of defaultUsers) {
      const passwordHash = await bcrypt.hash(user.password, saltRounds);
      await db.query(
        'INSERT INTO users (username, password_hash, name, email, role) VALUES (?, ?, ?, ?, ?)',
        [user.username, passwordHash, user.name, user.email, user.role]
      );
      created.push({ username: user.username, role: user.role });
    }

    res.json({ success: true, message: 'Default users created', users: created });
  } catch (error) {
    console.error('Setup error:', error);
    res.status(500).json({ success: false, error: 'Terjadi kesalahan saat setup' });
  }
});

export default router;

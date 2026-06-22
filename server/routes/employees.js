import express from 'express';
import bcrypt from 'bcryptjs';
import db from '../db.js';

const router = express.Router();

function generateNickname(fullName) {
  const parts = fullName.trim().split(' ');
  if (parts.length === 1) {
    return parts[0].toLowerCase();
  }
  return parts[0].toLowerCase();
}

router.get('/', async (req, res) => {
  try {
    const { status, department } = req.query;

    let query = 'SELECT * FROM employees WHERE 1=1';
    const params = [];

    if (status) {
      query += ' AND status = ?';
      params.push(status);
    }

    if (department) {
      query += ' AND department = ?';
      params.push(department);
    }

    query += ' ORDER BY name';

    const [employees] = await db.query(query, params);

    res.json({ success: true, data: employees });
  } catch (error) {
    console.error('Error fetching employees:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.post('/', async (req, res) => {
  const connection = await db.getConnection();

  try {
    await connection.beginTransaction();

    const { employee_code, name, nickname, email, phone, position, department, hire_date, salary, gender, birth_place, birth_date, address } = req.body;

    const [empResult] = await connection.query(
      `INSERT INTO employees (employee_code, name, email, phone, position, department, hire_date, salary, bio, address, birth_date)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [employee_code, name, email, phone, position, department, hire_date, salary,
       gender && birth_place ? `${gender === 'L' ? 'Laki-laki' : 'Perempuan'}, ${birth_place}` : null,
       address, birth_date]
    );

    const employeeId = empResult.insertId;

    // Use nickname for username if provided, otherwise generate from name
    const username = nickname ? nickname.toLowerCase().replace(/\s+/g, '') : generateNickname(name);
    const password = phone ? phone.replace(/\D/g, '') : '123456';
    const hashedPassword = await bcrypt.hash(password, 10);

    const roleMapping = {
      'IT': 'it',
      'Customer Service': 'customer_service',
      'Operations': 'operations',
      'Finance': 'finance',
      'HRD': 'admin',
      'Management': 'admin'
    };
    const role = roleMapping[department] || 'operations';

    let finalUsername = username;
    const [existingUsers] = await connection.query(
      'SELECT username FROM users WHERE username LIKE ?',
      [`${username}%`]
    );

    if (existingUsers.length > 0) {
      finalUsername = `${username}${existingUsers.length + 1}`;
    }

    await connection.query(
      `INSERT INTO users (username, password_hash, name, nickname, email, role, employee_id)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [finalUsername, hashedPassword, name, nickname || null, email, role, employeeId]
    );

    await connection.commit();

    res.status(201).json({
      success: true,
      data: {
        id: employeeId,
        user_created: true,
        username: finalUsername,
        default_password: password
      }
    });
  } catch (error) {
    await connection.rollback();
    console.error('Error creating employee:', error);
    res.status(500).json({ success: false, error: error.message });
  } finally {
    connection.release();
  }
});

router.post('/attendance', async (req, res) => {
  try {
    const { employee_id, attendance_date, check_in, check_out, status, work_hours, notes } = req.body;

    const [result] = await db.query(
      `INSERT INTO attendance (employee_id, attendance_date, check_in, check_out, status, work_hours, notes)
       VALUES (?, ?, ?, ?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE
         check_in = VALUES(check_in),
         check_out = VALUES(check_out),
         status = VALUES(status),
         work_hours = VALUES(work_hours),
         notes = VALUES(notes)`,
      [employee_id, attendance_date, check_in, check_out, status, work_hours, notes]
    );

    res.status(201).json({
      success: true,
      data: { id: result.insertId }
    });
  } catch (error) {
    console.error('Error marking attendance:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.post('/attendance/check-in', async (req, res) => {
  try {
    const { employee_id } = req.body;
    const today = new Date().toISOString().split('T')[0];
    const checkInTime = new Date().toTimeString().split(' ')[0];

    const hour = new Date().getHours();
    const minute = new Date().getMinutes();
    const status = (hour > 8 || (hour === 8 && minute > 0)) ? 'LATE' : 'PRESENT';

    const [result] = await db.query(
      `INSERT INTO attendance (employee_id, attendance_date, check_in, status)
       VALUES (?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE
         check_in = VALUES(check_in),
         status = VALUES(status)`,
      [employee_id, today, checkInTime, status]
    );

    res.status(201).json({
      success: true,
      data: {
        id: result.insertId,
        check_in: checkInTime,
        status,
        message: status === 'LATE' ? 'Terlambat! Jam masuk adalah 08:00 WIB' : 'Tepat waktu'
      }
    });
  } catch (error) {
    console.error('Error checking in:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.post('/attendance/check-out', async (req, res) => {
  try {
    const { employee_id } = req.body;
    const today = new Date().toISOString().split('T')[0];
    const checkOutTime = new Date().toTimeString().split(' ')[0];

    const [attendance] = await db.query(
      'SELECT check_in FROM attendance WHERE employee_id = ? AND attendance_date = ?',
      [employee_id, today]
    );

    if (attendance.length === 0) {
      return res.status(400).json({ success: false, error: 'Belum check-in hari ini' });
    }

    const checkIn = attendance[0].check_in;
    const checkInDate = new Date(`${today}T${checkIn}`);
    const checkOutDate = new Date(`${today}T${checkOutTime}`);
    const workHours = ((checkOutDate - checkInDate) / (1000 * 60 * 60)).toFixed(1);

    const [result] = await db.query(
      `UPDATE attendance SET check_out = ?, work_hours = ?
       WHERE employee_id = ? AND attendance_date = ?`,
      [checkOutTime, workHours, employee_id, today]
    );

    res.json({
      success: true,
      data: {
        check_out: checkOutTime,
        work_hours: parseFloat(workHours)
      }
    });
  } catch (error) {
    console.error('Error checking out:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/attendance/summary', async (req, res) => {
  try {
    const { month } = req.query;

    let query = `
      SELECT
        e.id,
        e.name,
        e.department,
        COUNT(*) as total_days,
        SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) as present_days,
        SUM(CASE WHEN a.status = 'ABSENT' THEN 1 ELSE 0 END) as absent_days,
        SUM(CASE WHEN a.status = 'LATE' THEN 1 ELSE 0 END) as late_days,
        SUM(a.work_hours) as total_hours
      FROM employees e
      LEFT JOIN attendance a ON e.id = a.employee_id
      WHERE e.status = 'ACTIVE'
    `;

    const params = [];

    if (month) {
      query += ' AND DATE_FORMAT(a.attendance_date, "%Y-%m") = ?';
      params.push(month);
    } else {
      query += ' AND DATE_FORMAT(a.attendance_date, "%Y-%m") = DATE_FORMAT(CURDATE(), "%Y-%m")';
    }

    query += ' GROUP BY e.id, e.name, e.department';

    const [summary] = await db.query(query, params);

    res.json({ success: true, data: summary });
  } catch (error) {
    console.error('Error fetching attendance summary:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/attendance/today', async (req, res) => {
  try {
    const { employee_id } = req.query;
    const today = new Date().toISOString().split('T')[0];

    if (!employee_id) {
      return res.json({ success: true, data: null });
    }

    const [attendance] = await db.query(
      'SELECT * FROM attendance WHERE employee_id = ? AND attendance_date = ?',
      [employee_id, today]
    );

    if (attendance.length === 0) {
      return res.json({ success: true, data: null });
    }

    res.json({
      success: true,
      data: {
        check_in_time: attendance[0].check_in,
        check_out_time: attendance[0].check_out,
        status: attendance[0].status,
        work_hours: attendance[0].work_hours
      }
    });
  } catch (error) {
    console.error('Error fetching today attendance:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { month } = req.query;

    const [employees] = await db.query('SELECT * FROM employees WHERE id = ?', [id]);
    if (employees.length === 0) {
      return res.status(404).json({ success: false, error: 'Employee not found' });
    }

    let attendanceQuery = 'SELECT * FROM attendance WHERE employee_id = ?';
    const params = [id];

    if (month) {
      attendanceQuery += ' AND DATE_FORMAT(attendance_date, "%Y-%m") = ?';
      params.push(month);
    }

    attendanceQuery += ' ORDER BY attendance_date DESC';

    const [attendance] = await db.query(attendanceQuery, params);

    res.json({
      success: true,
      data: {
        ...employees[0],
        attendance
      }
    });
  } catch (error) {
    console.error('Error fetching employee:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email, phone, position, department, salary, status, bio, address, birth_date, emergency_contact, emergency_phone } = req.body;

    await db.query(
      `UPDATE employees
       SET name = ?, email = ?, phone = ?, position = ?, department = ?, salary = ?, status = ?,
           bio = COALESCE(?, bio), address = COALESCE(?, address), birth_date = COALESCE(?, birth_date),
           emergency_contact = COALESCE(?, emergency_contact), emergency_phone = COALESCE(?, emergency_phone)
       WHERE id = ?`,
      [name, email, phone, position, department, salary, status, bio, address, birth_date, emergency_contact, emergency_phone, id]
    );

    res.json({ success: true, data: { id, ...req.body } });
  } catch (error) {
    console.error('Error updating employee:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Leave Requests Routes
router.get('/leave-requests/all', async (req, res) => {
  try {
    const { status, employee_id } = req.query;

    let query = `
      SELECT lr.*, e.name as employee_name, e.department
      FROM leave_requests lr
      JOIN employees e ON lr.employee_id = e.id
      WHERE 1=1
    `;
    const params = [];

    if (status) {
      query += ' AND lr.status = ?';
      params.push(status);
    }

    if (employee_id) {
      query += ' AND lr.employee_id = ?';
      params.push(employee_id);
    }

    query += ' ORDER BY lr.created_at DESC';

    const [requests] = await db.query(query, params);
    res.json({ success: true, data: requests });
  } catch (error) {
    console.error('Error fetching leave requests:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.post('/leave-requests', async (req, res) => {
  try {
    const { employee_id, leave_type, start_date, end_date, reason } = req.body;

    const [result] = await db.query(
      `INSERT INTO leave_requests (employee_id, leave_type, start_date, end_date, reason)
       VALUES (?, ?, ?, ?, ?)`,
      [employee_id, leave_type, start_date, end_date, reason]
    );

    res.status(201).json({
      success: true,
      data: { id: result.insertId, message: 'Pengajuan izin berhasil dikirim' }
    });
  } catch (error) {
    console.error('Error creating leave request:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

router.put('/leave-requests/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { status, approved_by, notes } = req.body;

    await db.query(
      `UPDATE leave_requests
       SET status = ?, approved_by = ?, approved_at = NOW(), notes = ?
       WHERE id = ?`,
      [status, approved_by, notes, id]
    );

    res.json({ success: true, data: { id, status } });
  } catch (error) {
    console.error('Error updating leave request:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

export default router;

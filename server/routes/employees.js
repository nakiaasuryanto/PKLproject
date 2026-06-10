import express from 'express';
import db from '../db.js';

const router = express.Router();

// GET /api/employees - Get all employees
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

// GET /api/employees/:id - Get employee with attendance
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { month } = req.query; // YYYY-MM format

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

// POST /api/employees - Create employee
router.post('/', async (req, res) => {
  try {
    const { employee_code, name, email, phone, position, department, hire_date, salary } = req.body;

    const [result] = await db.query(
      `INSERT INTO employees (employee_code, name, email, phone, position, department, hire_date, salary)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [employee_code, name, email, phone, position, department, hire_date, salary]
    );

    res.status(201).json({
      success: true,
      data: { id: result.insertId }
    });
  } catch (error) {
    console.error('Error creating employee:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// PUT /api/employees/:id - Update employee
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email, phone, position, department, salary, status } = req.body;

    await db.query(
      `UPDATE employees
       SET name = ?, email = ?, phone = ?, position = ?, department = ?, salary = ?, status = ?
       WHERE id = ?`,
      [name, email, phone, position, department, salary, status, id]
    );

    res.json({ success: true, data: { id, ...req.body } });
  } catch (error) {
    console.error('Error updating employee:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// POST /api/employees/attendance - Mark attendance
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

// POST /api/employees/attendance/check-in - Check in for today
router.post('/attendance/check-in', async (req, res) => {
  try {
    const { employee_id } = req.body;
    const today = new Date().toISOString().split('T')[0];
    const checkInTime = new Date().toTimeString().split(' ')[0];

    // Determine status based on check-in time (late if after 08:30)
    const hour = new Date().getHours();
    const minute = new Date().getMinutes();
    const status = (hour > 8 || (hour === 8 && minute > 30)) ? 'LATE' : 'PRESENT';

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
        status
      }
    });
  } catch (error) {
    console.error('Error checking in:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// POST /api/employees/attendance/check-out - Check out for today
router.post('/attendance/check-out', async (req, res) => {
  try {
    const { employee_id } = req.body;
    const today = new Date().toISOString().split('T')[0];
    const checkOutTime = new Date().toTimeString().split(' ')[0];

    // Get check-in time to calculate work hours
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

// GET /api/employees/attendance/summary - Attendance summary
router.get('/attendance/summary', async (req, res) => {
  try {
    const { month } = req.query; // YYYY-MM format

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

export default router;

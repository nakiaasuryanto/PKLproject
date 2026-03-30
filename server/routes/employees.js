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

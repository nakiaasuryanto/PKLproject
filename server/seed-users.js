import bcrypt from 'bcryptjs';
import db from './db.js';

const users = [
  { username: 'admin', password: 'admin123', name: 'Administrator', nickname: 'Admin', email: 'admin@company.com', role: 'admin', employee_id: null },
  { username: 'rizki', password: '081234567890', name: 'Ahmad Rizki Pratama', nickname: 'Rizki', email: 'ahmad.rizki@company.com', role: 'it', employee_id: 1 },
  { username: 'siti', password: '081234567891', name: 'Siti Nurhaliza', nickname: 'Siti', email: 'siti.nurhaliza@company.com', role: 'admin', employee_id: 2 },
  { username: 'budi', password: '081234567892', name: 'Budi Santoso', nickname: 'Budi', email: 'budi.santoso@company.com', role: 'finance', employee_id: 3 },
  { username: 'dewi', password: '081234567893', name: 'Dewi Lestari', nickname: 'Dewi', email: 'dewi.lestari@company.com', role: 'customer_service', employee_id: 4 },
  { username: 'rina', password: '081234567894', name: 'Rina Wulandari', nickname: 'Rina', email: 'rina.wulandari@company.com', role: 'operations', employee_id: 5 },
  { username: 'agus', password: '081234567895', name: 'Agus Hermawan', nickname: 'Agus', email: 'agus.hermawan@company.com', role: 'operations', employee_id: 6 },
  { username: 'maya', password: '081234567896', name: 'Maya Sari', nickname: 'Maya', email: 'maya.sari@company.com', role: 'customer_service', employee_id: 7 },
  { username: 'lisa', password: '081234567897', name: 'Lisa Permata', nickname: 'Lisa', email: 'lisa.permata@company.com', role: 'operations', employee_id: 8 },
];

async function seedUsers() {
  console.log('Seeding users...');

  try {
    // Clear existing users
    await db.query('DELETE FROM user_sessions');
    await db.query('DELETE FROM users');

    for (const user of users) {
      const passwordHash = await bcrypt.hash(user.password, 10);

      await db.query(
        `INSERT INTO users (username, password_hash, name, nickname, email, role, employee_id, is_active)
         VALUES (?, ?, ?, ?, ?, ?, ?, TRUE)`,
        [user.username, passwordHash, user.name, user.nickname, user.email, user.role, user.employee_id]
      );

      console.log(`Created user: ${user.username} (password: ${user.password})`);
    }

    console.log('\nAll users created successfully!');
    console.log('\nLogin credentials:');
    console.log('==================');
    users.forEach(u => {
      console.log(`${u.username} / ${u.password} (${u.role})`);
    });

    process.exit(0);
  } catch (error) {
    console.error('Error seeding users:', error);
    process.exit(1);
  }
}

seedUsers();

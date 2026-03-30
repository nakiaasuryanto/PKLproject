import express from 'express';
import db from '../db.js';

const router = express.Router();

// GET /api/dashboard/overview - Complete dashboard overview
router.get('/overview', async (req, res) => {
  try {
    const { start_date, end_date } = req.query;

    const endDate = end_date || new Date().toISOString().split('T')[0];
    const startDate = start_date || new Date(new Date(endDate).getFullYear(), new Date(endDate).getMonth(), 1).toISOString().split('T')[0];

    // Calculate previous period dates (previous month)
    const currentEndDate = new Date(endDate);
    const currentStartDate = new Date(startDate);
    const prevEndDate = new Date(currentEndDate.getFullYear(), currentEndDate.getMonth(), 0);
    const prevStartDate = new Date(currentStartDate.getFullYear(), currentStartDate.getMonth() - 1, 1);

    // Sales stats - current period
    const [salesStats] = await db.query(`
      SELECT
        COUNT(*) as total_transactions,
        COALESCE(SUM(CASE WHEN transaction_type = 'SALE' THEN total_amount ELSE 0 END), 0) as total_sales,
        COALESCE(SUM(CASE WHEN transaction_type = 'EXPENSE' THEN total_amount ELSE 0 END), 0) as total_expenses
      FROM transactions
      WHERE transaction_date BETWEEN ? AND ?
    `, [startDate, endDate]);

    // Sales stats - previous period (for growth calculation)
    const [prevSalesStats] = await db.query(`
      SELECT
        COALESCE(SUM(CASE WHEN transaction_type = 'SALE' THEN total_amount ELSE 0 END), 0) as total_sales,
        COALESCE(SUM(CASE WHEN transaction_type = 'EXPENSE' THEN total_amount ELSE 0 END), 0) as total_expenses
      FROM transactions
      WHERE transaction_date BETWEEN ? AND ?
    `, [prevStartDate.toISOString().split('T')[0], prevEndDate.toISOString().split('T')[0]]);

    // Calculate growth percentages
    const currentSales = salesStats[0].total_sales || 0;
    const prevSales = prevSalesStats[0].total_sales || 0;
    const salesGrowth = prevSales > 0 ? ((currentSales - prevSales) / prevSales * 100).toFixed(1) : '0.0';
    const salesGrowthValue = parseFloat(salesGrowth);

    const currentExpenses = salesStats[0].total_expenses || 0;
    const prevExpenses = prevSalesStats[0].total_expenses || 0;
    const expenseGrowth = prevExpenses > 0 ? ((currentExpenses - prevExpenses) / prevExpenses * 100).toFixed(1) : '0.0';
    const expenseGrowthValue = parseFloat(expenseGrowth);

    // CRM stats
    const [crmStats] = await db.query(`
      SELECT
        COUNT(*) as total_customers,
        SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active_customers
      FROM customers
    `);

    // HR stats
    const [hrStats] = await db.query(`
      SELECT
        COUNT(*) as total_employees,
        SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) as active_employees
      FROM employees
    `);

    // Inventory stats
    const [inventoryStats] = await db.query(`
      SELECT
        COUNT(*) as total_skus,
        COALESCE(SUM(quantity), 0) as total_stock,
        COALESCE(SUM(CASE WHEN quantity < 10 THEN 1 ELSE 0 END), 0) as low_stock_items
      FROM stock_balances
    `);

    res.json({
      success: true,
      data: {
        sales: {
          ...salesStats[0],
          sales_growth: salesGrowthValue,
          sales_growth_label: salesGrowthValue >= 0 ? `+${salesGrowth}%` : `${salesGrowth}%`
        },
        expenses: {
          total: currentExpenses,
          growth: expenseGrowthValue,
          growth_label: expenseGrowthValue >= 0 ? `+${expenseGrowth}%` : `${expenseGrowth}%`
        },
        crm: crmStats[0],
        hr: hrStats[0],
        inventory: inventoryStats[0]
      }
    });
  } catch (error) {
    console.error('Error fetching dashboard overview:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// GET /api/dashboard/sales-trend - Sales trend data
router.get('/sales-trend', async (req, res) => {
  try {
    const { period = 'daily', limit = 30 } = req.query;

    let dateFormat;
    switch (period) {
      case 'monthly':
        dateFormat = '%Y-%m';
        break;
      case 'weekly':
        dateFormat = '%Y-%u';
        break;
      default:
        dateFormat = '%Y-%m-%d';
    }

    const [trend] = await db.query(`
      SELECT
        DATE_FORMAT(transaction_date, ?) as period,
        COUNT(*) as transaction_count,
        SUM(CASE WHEN transaction_type = 'SALE' THEN total_amount ELSE 0 END) as sales,
        SUM(CASE WHEN transaction_type = 'EXPENSE' THEN total_amount ELSE 0 END) as expenses
      FROM transactions
      GROUP BY period
      ORDER BY period DESC
      LIMIT ?
    `, [dateFormat, parseInt(limit)]);

    res.json({ success: true, data: trend.reverse() });
  } catch (error) {
    console.error('Error fetching sales trend:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// GET /api/dashboard/top-products - Top selling products
router.get('/top-products', async (req, res) => {
  try {
    const { limit = 10 } = req.query;

    const [topProducts] = await db.query(`
      SELECT
        p.id,
        p.name,
        p.code,
        COUNT(DISTINCT t.id) as sales_count
      FROM products p
      JOIN product_colors pc ON p.id = pc.product_id
      JOIN product_color_sizes pcs ON pc.id = pcs.product_color_id
      JOIN stock_movements sm ON pcs.id = sm.product_color_size_id
      JOIN transactions t ON sm.reference_id = t.id AND sm.reference_type = 'TRANSACTION'
      WHERE sm.reason_code = 'SALES_OUT'
      GROUP BY p.id, p.name, p.code
      ORDER BY sales_count DESC
      LIMIT ?
    `, [parseInt(limit)]);

    res.json({ success: true, data: topProducts });
  } catch (error) {
    console.error('Error fetching top products:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// GET /api/dashboard/recent-activities - Recent activities across modules
router.get('/recent-activities', async (req, res) => {
  try {
    const { limit = 20 } = req.query;

    // Recent transactions
    const [transactions] = await db.query(`
      SELECT
        'transaction' as type,
        t.id,
        t.transaction_type as title,
        t.total_amount as amount,
        t.transaction_date as date,
        t.pic as user
      FROM transactions t
      ORDER BY t.created_at DESC
      LIMIT ?
    `, [parseInt(limit)]);

    // Recent interactions
    const [interactions] = await db.query(`
      SELECT
        'interaction' as type,
        ci.id,
        ci.interaction_type as title,
        NULL as amount,
        ci.interaction_date as date,
        ci.pic as user
      FROM customer_interactions ci
      ORDER BY ci.created_at DESC
      LIMIT ?
    `, [parseInt(limit)]);

    // Recent stock movements
    const [movements] = await db.query(`
      SELECT
        'stock_movement' as type,
        sm.id,
        sm.movement_type as title,
        sm.quantity as amount,
        sm.movement_date as date,
        sm.created_by as user
      FROM stock_movements sm
      ORDER BY sm.created_at DESC
      LIMIT ?
    `, [parseInt(limit)]);

    // Combine and sort by date
    const allActivities = [
      ...transactions.map(t => ({ ...t, date: t.date || t.created_at })),
      ...interactions.map(i => ({ ...i, date: i.date || i.created_at })),
      ...movements.map(m => ({ ...m, date: m.date || m.created_at }))
    ].sort((a, b) => new Date(b.date) - new Date(a.date))
      .slice(0, parseInt(limit));

    res.json({ success: true, data: allActivities });
  } catch (error) {
    console.error('Error fetching recent activities:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

export default router;

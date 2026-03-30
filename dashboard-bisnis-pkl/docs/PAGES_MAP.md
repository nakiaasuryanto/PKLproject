# Pages & Routes Structure

Complete mapping of all pages, routes, and navigation in the Dashboard Bisnis PKL application.

---

## Public Routes

### Root Routes

| Route | Page | Module Color | Description |
|-------|------|--------------|-------------|
| `/` | Homepage | Multi | Landing page with navigation cards to all modules |
| `/sales` | Sales Dashboard | Red (#EF4444) | Sales transactions, performance, analytics |
| `/finance` | Finance Dashboard | Gray (#6B7280) | Revenue, expenses, cash flow, P&L |
| `/inventory` | Inventory Management | Yellow (#F59E0B) | Stock status, movements, alerts |
| `/crm` | CRM Module | Green (#10B981) | Customer management, interactions |
| `/hr` | HR Module | Blue (#3B82F6) | Employee directory, attendance |

---

## Detailed Page Breakdown

### `/` - Homepage

**Purpose:** Main landing page with navigation to all modules

**Components:**
- Hero section with project title
- Module navigation cards (5 cards, one per module)
- Quick stats overview (optional)
- Footer

**Navigation Cards:**
| Module | Title | Icon | Link | Color |
|--------|-------|------|------|-------|
| Sales | Sales Dashboard | 📊 | /sales | Red |
| Finance | Finance Dashboard | 💰 | /finance | Gray |
| Inventory | Inventory | 📦 | /inventory | Yellow |
| CRM | Customer Relations | 👥 | /crm | Green |
| HR | Human Resources | 👤 | /hr | Blue |

**File Location:** `src/pages/index.astro`

---

### `/sales` - Sales Dashboard

**Purpose:** Sales transaction management and analytics

**Features:**
- Transaction summary per period
- Sales performance comparison charts
- Recent transactions table
- Sales by product/service
- Sales by customer (CRM link)

**Sub-sections:**
- Overview (summary cards)
- Transactions (table with filters)
- Analytics (charts: trends, comparisons)
- Reports (exportable)

**File Location:** `src/pages/sales.astro`

**Color Theme:** Red (#EF4444)

---

### `/finance` - Finance Dashboard

**Purpose:** Financial overview and management

**Features:**
- Revenue & expense summary
- Cash flow overview
- Profit & Loss statement
- Balance sheet view
- Financial charts

**Sub-sections:**
- Overview (summary cards)
- Revenue (breakdown by source)
- Expenses (by category)
- Cash Flow (in/out tracking)
- Reports (P&L, Balance Sheet)

**File Location:** `src/pages/finance.astro`

**Color Theme:** Gray (#6B7280)

---

### `/inventory` - Inventory Management

**Purpose:** Stock and inventory management

**Features:**
- Stock quantity status
- Stock changes over period
- Low stock alerts
- Stock movements (in/out)
- Product management

**Sub-sections:**
- Overview (summary cards, alerts)
- Stock Status (table with filters)
- Movements (history table)
- Products (manage items)

**File Location:** `src/pages/inventory.astro`

**Color Theme:** Yellow (#F59E0B)

---

### `/crm` - CRM Module

**Purpose:** Customer relationship management

**Features:**
- Active customer count
- Customer interaction activities
- Customer profiles
- Communication history
- Customer analytics

**Sub-sections:**
- Overview (customer count, activity summary)
- Customers (directory table)
- Interactions (activity log)
- Analytics (customer metrics)

**File Location:** `src/pages/crm.astro`

**Color Theme:** Green (#10B981)

---

### `/hr` - HR Module

**Purpose:** Human resources and attendance management

**Features:**
- Active employee count
- Employee attendance info
- Employee directory
- Leave management
- HR analytics

**Sub-sections:**
- Overview (employee count, attendance summary)
- Employees (directory table)
- Attendance (tracking, reports)
- Analytics (HR metrics)

**File Location:** `src/pages/hr.astro`

**Color Theme:** Blue (#3B82F6)

---

## Future Routes (Optional)

### Authentication

| Route | Page | Description |
|-------|------|-------------|
| `/login` | Login Page | User authentication |
| `/logout` | Logout Action | End user session |
| `/register` | Registration | New user signup (if needed) |

### User Management

| Route | Page | Description |
|-------|------|-------------|
| `/profile` | User Profile | Edit user settings |
| `/settings` | Settings | Application preferences |

### Advanced Features

| Route | Page | Description |
|-------|------|-------------|
| `/sales/:id` | Transaction Detail | View specific transaction |
| `/finance/reports/:type` | Financial Report | Specific report type |
| `/inventory/:id` | Product Detail | View/edit product |
| `/crm/:id` | Customer Detail | Customer profile |
| `/hr/:id` | Employee Detail | Employee profile |

---

## Layout Structure

### BaseLayout

**Purpose:** Root layout for all pages

**Includes:**
- HTML structure
- Head tags (meta, fonts)
- Global styles
- Font imports (Montserrat)

**File:** `src/layouts/BaseLayout.astro`

---

### MainLayout

**Purpose:** Main content layout with navigation

**Includes:**
- Navbar (top navigation)
- Main content area
- Footer

**File:** `src/layouts/MainLayout.astro`

---

### Navbar Component

**Features:**
- Logo/brand name
- Navigation links (to all 5 modules)
- Home link
- Mobile hamburger menu
- Active route highlighting
- Module-specific colors

**File:** `src/components/Navbar.astro`

---

### Footer Component

**Features:**
- Copyright info
- Project name
- Digital360 branding
- Optional: Links to docs

**File:** `src/components/Footer.astro`

---

## Navigation Flow

### Primary Navigation

```
┌─────────────────────────────────────┐
│          Navbar (MainLayout)        │
├─────────────────────────────────────┤
│                                     │
│                                     │
│         Main Content Area           │
│                                     │
│                                     │
├─────────────────────────────────────┤
│          Footer (MainLayout)        │
└─────────────────────────────────────┘
```

### Homepage Navigation

```
              Homepage (/)
                    │
    ┌───────────┬───┼────┬───────────┐
    │           │   │    │           │
    ▼           ▼   ▼    ▼           ▼
  /sales   /finance  /inventory  /crm  /hr
   (Red)    (Gray)   (Yellow)  (Green) (Blue)
```

---

## URL Parameters & Query Strings

### Filters and Search

| Page | Parameter | Example | Description |
|------|-----------|---------|-------------|
| /sales | `?period=today` | /sales?period=today | Filter by period |
| /sales | `?search=query` | /sales?search=ABC | Search transactions |
| /inventory | `?status=low` | /inventory?status=low | Filter low stock |
| /crm | `?search=name` | /crm?search=John | Search customers |
| /hr | `?status=present` | /hr?status=present | Filter attendance |

### Pagination

| Pattern | Example | Description |
|---------|---------|-------------|
| `?page=1` | /sales?page=1 | Page number |
| `?limit=20` | /sales?limit=20 | Items per page |
| `?page=1&limit=50` | /sales?page=1&limit=50 | Combined |

---

## Component File Structure

```
src/
├── layouts/
│   ├── BaseLayout.astro
│   └── MainLayout.astro
│
├── components/
│   ├── shared/
│   │   ├── Navbar.astro
│   │   ├── Footer.astro
│   │   ├── Card.astro
│   │   ├── Button.astro
│   │   ├── Table.astro
│   │   └── ChartWrapper.astro
│   │
│   ├── sales/
│   │   └── SalesCard.astro
│   │
│   ├── finance/
│   │   └── FinanceCard.astro
│   │
│   ├── inventory/
│   │   └── InventoryCard.astro
│   │
│   ├── crm/
│   │   └── CRMCard.astro
│   │
│   └── hr/
│       └── HRCard.astro
│
└── pages/
    ├── index.astro          (Homepage)
    ├── sales.astro          (Sales)
    ├── finance.astro        (Finance)
    ├── inventory.astro      (Inventory)
    ├── crm.astro            (CRM)
    └── hr.astro             (HR)
```

---

## Routing Notes

1. **All routes are server-rendered** by Astro
2. **No client-side routing** initially (can be added later)
3. **Active state detection** via URL matching
4. **Module colors applied** at page/component level
5. **Responsive design** - all pages work on mobile

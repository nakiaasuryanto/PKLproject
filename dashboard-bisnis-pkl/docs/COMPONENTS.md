# Component Library - Dashboard Bisnis PKL

Reference for all shared and module-specific components.

---

## Shared Components

### Navbar

**File:** `src/components/shared/Navbar.astro`

**Purpose:** Top navigation bar for all pages

**Props:**
- `currentRoute`: string - Current page route for active state

**Features:**
- Logo/brand name
- Links to all 5 modules
- Home link
- Mobile hamburger menu
- Active route highlighting with module colors

**Usage:**
```astro
<Navbar currentRoute="/sales" />
```

---

### Footer

**File:** `src/components/shared/Footer.astro`

**Purpose:** Site footer

**Features:**
- Copyright information
- Project name
- Digital360 branding

**Usage:**
```astro
<Footer />
```

---

### Card

**File:** `src/components/shared/Card.astro`

**Purpose:** Reusable card component with module-specific styling

**Props:**
- `title`: string - Card title
- `value`: string - Main value to display
- `color`: 'sales' | 'finance' | 'crm' | 'hr' | 'inventory' - Module color
- `icon`?: string - Optional icon
- `trend`?: string - Optional trend indicator (e.g., "+12%")
- `trendUp`?: boolean - True for positive trend, false for negative

**Usage:**
```astro
<Card
  title="Total Sales"
  value="Rp 150.000.000"
  color="sales"
  icon="📊"
  trend="+12%"
  trendUp={true}
/>
```

---

### Button

**File:** `src/components/shared/Button.astro`

**Purpose:** Reusable button component

**Props:**
- `label`: string - Button text
- `variant`: 'primary' | 'secondary' | 'outline' - Button style
- `color`: 'sales' | 'finance' | 'crm' | 'hr' | 'inventory' - Module color
- `onClick`?: string - Optional onclick handler
- `href`?: string - Optional link (renders as <a>)

**Usage:**
```astro
<Button label="Submit" variant="primary" color="sales" />
<Button label="Cancel" variant="secondary" />
<Button label="Details" variant="outline" color="crm" href="/crm/123" />
```

---

### Table

**File:** `src/components/shared/Table.astro`

**Purpose:** Reusable table component

**Props:**
- `columns`: Array<{key: string, label: string}> - Column definitions
- `data`: Array<Record<string, any>> - Table data
- `color`: 'sales' | 'finance' | 'crm' | 'hr' | 'inventory' - Module color for header
- `sortable`?: boolean - Enable sorting
- `pagination`?: {page: number, limit: number, total: number} - Pagination info

**Usage:**
```astro
<Table
  columns={[
    {key: 'name', label: 'Name'},
    {key: 'email', label: 'Email'},
    {key: 'status', label: 'Status'}
  ]}
  data={customers}
  color="crm"
  sortable={true}
/>
```

---

### ChartWrapper

**File:** `src/components/shared/ChartWrapper.astro`

**Purpose:** Wrapper for Chart.js charts with consistent styling

**Props:**
- `title`: string - Chart title
- `type`: 'line' | 'bar' | 'pie' | 'doughnut' - Chart type
- `data`: object - Chart.js data object
- `options`?: object - Chart.js options
- `color`: string - Primary color for chart

**Usage:**
```astro
<ChartWrapper
  title="Sales Trend"
  type="line"
  data={chartData}
  color="#EF4444"
/>
```

---

## Sales Components

### SalesCard

**File:** `src/components/sales/SalesCard.astro`

**Purpose:** Sales-specific summary card with red theme

**Props:**
- `title`: string
- `value`: string
- `period`: string

**Usage:**
```astro
<SalesCard title="Today's Sales" value="Rp 25.000.000" period="Today" />
```

---

## Finance Components

### FinanceCard

**File:** `src/components/finance/FinanceCard.astro`

**Purpose:** Finance-specific summary card with gray theme

**Props:**
- `title`: string
- `value`: string
- `type`: 'revenue' | 'expense'

**Usage:**
```astro
<FinanceCard title="Total Revenue" value="Rp 500.000.000" type="revenue" />
<FinanceCard title="Total Expenses" value="Rp 150.000.000" type="expense" />
```

---

## Inventory Components

### InventoryCard

**File:** `src/components/inventory/InventoryCard.astro`

**Purpose:** Inventory-specific card with yellow theme

**Props:**
- `title`: string
- `value`: string
- `status`: 'ok' | 'low' | 'out'

**Usage:**
```astro
<InventoryCard title="Total Products" value="150" status="ok" />
<InventoryCard title="Low Stock Items" value="5" status="low" />
```

---

## CRM Components

### CRMCard

**File:** `src/components/crm/CRMCard.astro`

**Purpose:** CRM-specific card with green theme

**Props:**
- `title`: string
- `value`: string
- `subtitle`?: string

**Usage:**
```astro
<CRMCard title="Active Customers" value="125" subtitle="+5 this month" />
```

---

## HR Components

### HRCard

**File:** `src/components/hr/HRCard.astro`

**Purpose:** HR-specific card with blue theme

**Props:**
- `title`: string
- `value`: string
- `subtitle`?: string

**Usage:**
```astro
<HRCard title="Total Employees" value="45" subtitle="3 on leave" />
```

---

## Layout Components

### BaseLayout

**File:** `src/layouts/BaseLayout.astro`

**Purpose:** Root layout with HTML structure

**Slots:**
- Default slot for page content

**Features:**
- HTML5 structure
- Meta tags
- Font imports (Montserrat)
- Global styles
- Chart.js CDN

**Usage:**
```astro
<BaseLayout title="Page Title">
  <main>Page content</main>
</BaseLayout>
```

---

### MainLayout

**File:** `src/layouts/MainLayout.astro`

**Purpose:** Main content layout with Navbar and Footer

**Props:**
- `title`: string - Page title
- `currentRoute`: string - Current route for Navbar

**Slots:**
- Default slot for page content

**Features:**
- Includes Navbar
- Main content area with padding
- Includes Footer

**Usage:**
```astro
<MainLayout title="Sales Dashboard" currentRoute="/sales">
  <h1>Sales Dashboard</h1>
  <!-- Page content -->
</MainLayout>
```

---

## Component Status

```
Component Implementation Status:

Shared Components (src/components/):
- Navbar: ✅ Complete (supports activeModule prop, mobile-responsive)
- Footer: ✅ Complete
- Sidebar: ✅ Complete

UI Components (src/components/ui/):
- Card: ✅ Complete (supports title, color props)
- StatCard: ✅ Complete (supports value, change, changeType, color, icon)
- Button: ✅ Complete (supports variant, color, size, href)

Chart Components (src/components/charts/):
- ChartWrapper: ✅ Complete (integrates Chart.js)

Layouts (src/layouts/):
- BaseHead: ✅ Complete (HTML head with fonts and meta tags)
- MainLayout: ✅ Complete (includes Navbar, main content area, responsive)

Pages (src/pages/):
- index.astro: ✅ Complete (Homepage with module cards)
- sales.astro: ✅ Complete (Sales dashboard with charts and tables)
- finance.astro: ✅ Complete (Finance dashboard)
- inventory.astro: ✅ Complete (Inventory management)
- crm.astro: ✅ Complete (Customer management)
- hr.astro: ✅ Complete (Employee management)

Utilities:
- tailwind.config.js: ✅ Complete (full color system configured)
- chartUtils.ts: ✅ Complete (Chart.js helper functions)
- api.ts: ✅ Complete (API client for backend communication)
```

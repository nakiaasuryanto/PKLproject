# Component Documentation

Dashboard Bisnis Terintegrasi - Nakia Suryanto's PKL Project

---

## Table of Contents

1. [Layouts](#layouts)
2. [Navigation Components](#navigation-components)
3. [UI Components](#ui-components)
4. [Chart Components](#chart-components)
5. [API Client](#api-client)
6. [Chart Utilities](#chart-utilities)
7. [Design System](#design-system)

---

## Layouts

### MainLayout

**Location:** `src/layouts/MainLayout.astro`

Main layout wrapper for all pages. Includes Navbar, Sidebar, and Footer.

**Usage:**
```astro
---
import MainLayout from '../layouts/MainLayout.astro';
---

<MainLayout
  title="Page Title"
  description="Optional meta description"
  activeModule="sales"
>
  <h1>Your content here</h1>
</MainLayout>
```

**Props:**
| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| title | `string` | Yes | - | Page title |
| description | `string` | No | `'Dashboard Bisnis Terintegrasi...'` | Meta description |
| activeModule | `'sales' \| 'finance' \| 'crm' \| 'hr' \| 'inventory' \| 'home'` | No | `'home'` | Active module for highlighting nav |

### BaseHead

**Location:** `src/layouts/BaseHead.astro`

HTML head component with Montserrat font.

**Usage:**
```astro
---
import BaseHead from '../layouts/BaseHead.astro';
---

<BaseHead title="Page Title" description="Meta description" />
```

---

## Navigation Components

### Navbar

**Location:** `src/components/Navbar.astro`

Top navigation bar with module links and user menu.

**Usage:**
```astro
---
import Navbar from '../components/Navbar.astro';
---

<Navbar activeModule="sales" />
```

**Props:**
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| activeModule | `string` | `'home'` | Active module for highlighting |

### Sidebar

**Location:** `src/components/Sidebar.astro`

Side navigation with module links and quick actions.

**Usage:**
```astro
---
import Sidebar from '../components/Sidebar.astro';
---

<Sidebar activeModule="finance" />
```

### Footer

**Location:** `src/components/Footer.astro`

Page footer with copyright information.

**Usage:**
```astro
---
import Footer from '../components/Footer.astro';
---

<Footer />
```

---

## UI Components

### Card

**Location:** `src/components/ui/Card.astro`

Reusable card component with optional title.

**Usage:**
```astro
---
import Card from '../components/ui/Card.astro';
---

<Card title="Card Title" color="sales">
  <p>Card content goes here</p>
</Card>
```

**Props:**
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| title | `string` | - | Card title |
| color | `'sales' \| 'finance' \| 'crm' \| 'hr' \| 'inventory' \| 'gray'` | `'gray'` | Module color |
| className | `string` | `''` | Additional CSS classes |
| noPadding | `boolean` | `false` | Remove default padding |
| headerAction | `boolean` | `false` | Enable header action slot |

### Button

**Location:** `src/components/ui/Button.astro`

Flexible button component with multiple variants.

**Usage:**
```astro
---
import Button from '../components/ui/Button.astro';
---

<!-- Primary button -->
<Button variant="primary" color="sales" size="md">
  Click Me
</Button>

<!-- Secondary button -->
<Button variant="secondary" color="finance" size="lg">
  Cancel
</Button>

<!-- Link button -->
<Button variant="outline" color="crm" href="/page">
  Go to Page
</Button>
```

**Props:**
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| variant | `'primary' \| 'secondary' \| 'outline' \| 'ghost'` | `'primary'` | Button style |
| color | `'sales' \| 'finance' \| 'crm' \| 'hr' \| 'inventory' \| 'gray'` | `'gray'` | Module color |
| size | `'sm' \| 'md' \| 'lg'` | `'md'` | Button size |
| type | `'button' \| 'submit' \| 'reset'` | `'button'` | Button type |
| href | `string` | - | Render as link if provided |
| disabled | `boolean` | `false` | Disabled state |
| className | `string` | `''` | Additional CSS classes |

### StatCard

**Location:** `src/components/ui/StatCard.astro`

Stat card for displaying metrics with change indicators.

**Usage:**
```astro
---
import StatCard from '../components/ui/StatCard.astro';
---

<StatCard
  title="Total Sales"
  value="Rp 125.5M"
  change="+12.5% from last month"
  changeType="positive"
  color="sales"
  icon="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"
  href="/sales"
/>
```

**Props:**
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| title | `string` | Yes | Stat title |
| value | `string \| number` | Yes | Stat value |
| change | `string` | - | Change text |
| changeType | `'positive' \| 'negative' \| 'neutral'` | `'neutral'` | Change indicator style |
| color | `'sales' \| 'finance' \| 'crm' \| 'hr' \| 'inventory'` | `'sales'` | Module color |
| icon | `string` | - | SVG path data |
| href | `string` | - | Make card clickable link |

---

## Chart Components

### ChartWrapper

**Location:** `src/components/charts/ChartWrapper.astro`

Container component for Chart.js canvases.

**Usage:**
```astro
---
import ChartWrapper from '../components/charts/ChartWrapper.astro';
---

<ChartWrapper
  chartId="myChart"
  title="Chart Title"
  description="Optional description"
  height="300px"
/>
```

**Props:**
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| chartId | `string` | Yes | Unique canvas ID |
| title | `string` | - | Chart title |
| description | `string` | - | Chart description |
| height | `string` | `'300px'` | Container height |
| className | `string` | `''` | Additional CSS classes |

---

## API Client

**Location:** `src/lib/api.ts`

TypeScript API client with typed endpoints.

### Basic Usage

```typescript
import { api, salesApi, financeApi } from '../lib/api';

// Generic API calls
const response = await api.get('/endpoint');
if (response.success) {
  console.log(response.data);
}

// Sales endpoints
const orders = await salesApi.getOrders();
const order = await salesApi.getOrder('ORD-001');
const newOrder = await salesApi.createOrder({
  customerId: 'CUST-001',
  items: [...],
  total: 15000000
});

// Finance endpoints
const transactions = await financeApi.getTransactions();
const stats = await financeApi.getStats();

// Inventory endpoints
const products = await inventoryApi.getProducts();
const lowStock = await inventoryApi.getLowStock();

// CRM endpoints
const contacts = await crmApi.getContacts();
const deals = await crmApi.getDeals();

// HR endpoints
const employees = await hrApi.getEmployees();
const payroll = await hrApi.getPayroll();

// Dashboard endpoints
const overview = await dashboardApi.getOverview();
```

### API Methods

| Method | Description |
|--------|-------------|
| `api.get<T>(endpoint, options?)` | GET request |
| `api.post<T>(endpoint, body, options?)` | POST request |
| `api.put<T>(endpoint, body, options?)` | PUT request |
| `api.patch<T>(endpoint, body, options?)` | PATCH request |
| `api.delete<T>(endpoint, options?)` | DELETE request |

### Response Type

```typescript
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}
```

---

## Chart Utilities

**Location:** `src/lib/chartUtils.ts`

Chart.js helper functions with module colors.

### Available Chart Types

```typescript
import {
  createAreaChart,
  createLineChart,
  createBarChart,
  createHorizontalBarChart,
  createDoughnutChart,
  createPieChart,
  destroyChart,
  moduleColors
} from '../lib/chartUtils';

// Area Chart (filled line)
createAreaChart('chartId', labels, datasets, options?);

// Line Chart
createLineChart('chartId', labels, datasets, options?);

// Bar Chart
createBarChart('chartId', labels, datasets, options?);

// Horizontal Bar Chart
createHorizontalBarChart('chartId', labels, datasets, options?);

// Doughnut Chart
createDoughnutChart('chartId', labels, data, backgroundColor?, options?);

// Pie Chart
createPieChart('chartId', labels, data, backgroundColor?, options?);

// Destroy chart instance
destroyChart('chartId');
```

### Module Colors

```typescript
moduleColors.sales.primary      // '#EF4444'
moduleColors.finance.primary    // '#6B7280'
moduleColors.crm.primary        // '#10B981'
moduleColors.hr.primary         // '#3B82F6'
moduleColors.inventory.primary  // '#F59E0B'
```

### Example Usage in Page

```astro
<script>
  import { createAreaChart, createBarChart } from '../lib/chartUtils';

  document.addEventListener('DOMContentLoaded', () => {
    createAreaChart('salesChart',
      ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun'],
      [{
        label: 'Penjualan 2024',
        data: [65, 78, 90, 81, 95, 112],
      }]
    );

    createBarChart('revenueChart',
      ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun'],
      [
        { label: 'Pendapatan', data: [45, 52, 60, 54, 62, 75] },
        { label: 'Pengeluaran', data: [30, 35, 38, 32, 40, 45] }
      ]
    );
  });
</script>
```

---

## Design System

### Module Colors

| Module | Primary Color | Hex | Usage |
|--------|--------------|-----|-------|
| Sales | Red | `#EF4444` | Penjualan, orders |
| Finance | Gray | `#6B7280` | Keuangan, invoices |
| CRM | Green | `#10B981` | Pelanggan, deals |
| HR | Blue | `#3B82F6` | Karyawan, payroll |
| Inventory | Yellow | `#F59E0B` | Produk, stok |

### Typography

**Font Family:** Montserrat

- **Weights:** 300 (Light), 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold), 800 (ExtraBold)
- **Base Size:** 14px / 0.875rem
- **Line Height:** 1.5

### Spacing Scale

- `4px` - `0.25rem`
- `8px` - `0.5rem`
- `12px` - `0.75rem`
- `16px` - `1rem`
- `24px` - `1.5rem`
- `32px` - `2rem`
- `48px` - `3rem`

### Border Radius

- `sm`: `0.25rem` - 4px
- `md`: `0.375rem` - 6px
- `lg`: `0.5rem` - 8px
- `xl`: `0.75rem` - 12px

### Shadows

- `shadow-sm` - Small elevation
- `shadow` - Default elevation
- `shadow-md` - Medium elevation
- `shadow-lg` - Large elevation

---

## Getting Started

### Development Server

```bash
cd frontend
npm run dev
```

Server runs at `http://localhost:4321`

### Building for Production

```bash
npm run build
```

Output is in `dist/` directory.

### API Proxy

The frontend proxies `/api` requests to the backend at `http://localhost:3001`.

---

## Page Structure

```
src/pages/
├── index.astro         # Home / Dashboard
├── sales.astro         # Sales module
├── finance.astro       # Finance module
├── inventory.astro     # Inventory module
├── crm.astro           # CRM module
└── hr.astro            # HR module
```

---

## Component Structure

```
src/
├── layouts/
│   ├── BaseHead.astro
│   └── MainLayout.astro
├── components/
│   ├── Navbar.astro
│   ├── Sidebar.astro
│   ├── Footer.astro
│   ├── ui/
│   │   ├── Card.astro
│   │   ├── Button.astro
│   │   └── StatCard.astro
│   └── charts/
│       └── ChartWrapper.astro
├── lib/
│   ├── api.ts
│   └── chartUtils.ts
└── styles/
    └── global.css
```

---

## License

Nakia Suryanto's PKL Project

© 2024

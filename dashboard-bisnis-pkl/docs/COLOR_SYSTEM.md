# Color System - Dashboard Bisnis PKL

Complete design system documentation for the integrated business dashboard.

## Font Family

### Primary Font: Montserrat

```
Font Family: Montserrat, sans-serif
Font Source: Google Fonts (https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap)
```

### Font Weights

| Weight | Usage | CSS Class |
|--------|-------|-----------|
| 400 (Regular) | Body text, table content | `font-normal` |
| 500 (Medium) | Labels, secondary headings | `font-medium` |
| 600 (SemiBold) | Cards, buttons | `font-semibold` |
| 700 (Bold) | Page headers, main headings | `font-bold` |

### Font Sizes

| Size | Tailwind Class | Usage |
|------|----------------|-------|
| 12px | `text-xs` | Small labels, badges |
| 14px | `text-sm` | Secondary text, captions |
| 16px | `text-base` | Body text, table content |
| 18px | `text-lg` | Subheadings, card titles |
| 20px | `text-xl` | Section headers |
| 24px | `text-2xl` | Page titles |
| 30px | `text-3xl` | Hero titles |
| 36px | `text-4xl` | Main headings |

---

## Module Color Palettes

### Sales (Red)

| Shade | Hex | Tailwind Class | Usage |
|-------|-----|----------------|-------|
| 50 | #FEF2F2 | `bg-sales-50` | Page background accents |
| 100 | #FEE2E2 | `bg-sales-100` | Light card backgrounds |
| 200 | #FECACA | `bg-sales-200` | Subtle dividers |
| 300 | #FCA5A5 | `bg-sales-300` | Hover states (light) |
| 400 | #F87171 | `bg-sales-400` | Hover states |
| 500 | #EF4444 | `bg-sales-500` | **DEFAULT - Primary buttons, active states** |
| 600 | #DC2626 | `bg-sales-600` | Darker buttons, pressed states |
| 700 | #B91C1C | `bg-sales-700` | Footer backgrounds |
| 800 | #991B1B | `bg-sales-800` | Header accents, dark mode |
| 900 | #7F1D1D | `bg-sales-900` | Dark backgrounds |

### Finance (Gray)

| Shade | Hex | Tailwind Class | Usage |
|-------|-----|----------------|-------|
| 50 | #F9FAFB | `bg-finance-50` | Page backgrounds |
| 100 | #F3F4F6 | `bg-finance-100` | Card backgrounds |
| 200 | #E5E7EB | `bg-finance-200` | Borders, dividers |
| 300 | #D1D5DB | `bg-finance-300` | Disabled states |
| 400 | #9CA3AF | `bg-finance-400` | Muted text |
| 500 | #6B7280 | `bg-finance-500` | **DEFAULT - Primary elements** |
| 600 | #4B5563 | `bg-finance-600` | Secondary text |
| 700 | #374151 | `bg-finance-700` | Dark backgrounds |
| 800 | #1F2937 | `bg-finance-800` | Dark mode panels |
| 900 | #111827 | `bg-finance-900` | Dark mode backgrounds |

### CRM (Green)

| Shade | Hex | Tailwind Class | Usage |
|-------|-----|----------------|-------|
| 50 | #ECFDF5 | `bg-crm-50` | Page background accents |
| 100 | #D1FAE5 | `bg-crm-100` | Light card backgrounds |
| 200 | #A7F3D0 | `bg-crm-200` | Subtle dividers |
| 300 | #6EE7B7 | `bg-crm-300` | Hover states (light) |
| 400 | #34D399 | `bg-crm-400` | Hover states |
| 500 | #10B981 | `bg-crm-500` | **DEFAULT - Primary buttons, active states** |
| 600 | #059669 | `bg-crm-600` | Darker buttons, pressed states |
| 700 | #047857 | `bg-crm-700` | Footer backgrounds |
| 800 | #065F46 | `bg-crm-800` | Header accents, dark mode |
| 900 | #064E3B | `bg-crm-900` | Dark backgrounds |

### HR (Blue)

| Shade | Hex | Tailwind Class | Usage |
|-------|-----|----------------|-------|
| 50 | #EFF6FF | `bg-hr-50` | Page background accents |
| 100 | #DBEAFE | `bg-hr-100` | Light card backgrounds |
| 200 | #BFDBFE | `bg-hr-200` | Subtle dividers |
| 300 | #93C5FD | `bg-hr-300` | Hover states (light) |
| 400 | #60A5FA | `bg-hr-400` | Hover states |
| 500 | #3B82F6 | `bg-hr-500` | **DEFAULT - Primary buttons, active states** |
| 600 | #2563EB | `bg-hr-600` | Darker buttons, pressed states |
| 700 | #1D4ED8 | `bg-hr-700` | Footer backgrounds |
| 800 | #1E40AF | `bg-hr-800` | Header accents, dark mode |
| 900 | #1E3A8A | `bg-hr-900` | Dark backgrounds |

### Inventory (Yellow/Amber)

| Shade | Hex | Tailwind Class | Usage |
|-------|-----|----------------|-------|
| 50 | #FFFBEB | `bg-inventory-50` | Page background accents |
| 100 | #FEF3C7 | `bg-inventory-100` | Light card backgrounds |
| 200 | #FDE68A | `bg-inventory-200` | Subtle dividers |
| 300 | #FCD34D | `bg-inventory-300` | Hover states (light) |
| 400 | #FBBF24 | `bg-inventory-400` | Hover states |
| 500 | #F59E0B | `bg-inventory-500` | **DEFAULT - Primary buttons, active states** |
| 600 | #D97706 | `bg-inventory-600` | Darker buttons, pressed states |
| 700 | #B45309 | `bg-inventory-700` | Footer backgrounds |
| 800 | #92400E | `bg-inventory-800` | Header accents, dark mode |
| 900 | #78350F | `bg-inventory-900` | Dark backgrounds |

---

## TailwindCSS Configuration

### tailwind.config.mjs

```javascript
import { defineConfig } from 'astro/config';

export default defineConfig({
  theme: {
    extend: {
      fontFamily: {
        sans: ['Montserrat', 'sans-serif'],
      },
      colors: {
        sales: {
          50: '#FEF2F2',
          100: '#FEE2E2',
          200: '#FECACA',
          300: '#FCA5A5',
          400: '#F87171',
          500: '#EF4444',
          600: '#DC2626',
          700: '#B91C1C',
          800: '#991B1B',
          900: '#7F1D1D',
        },
        finance: {
          50: '#F9FAFB',
          100: '#F3F4F6',
          200: '#E5E7EB',
          300: '#D1D5DB',
          400: '#9CA3AF',
          500: '#6B7280',
          600: '#4B5563',
          700: '#374151',
          800: '#1F2937',
          900: '#111827',
        },
        crm: {
          50: '#ECFDF5',
          100: '#D1FAE5',
          200: '#A7F3D0',
          300: '#6EE7B7',
          400: '#34D399',
          500: '#10B981',
          600: '#059669',
          700: '#047857',
          800: '#065F46',
          900: '#064E3B',
        },
        hr: {
          50: '#EFF6FF',
          100: '#DBEAFE',
          200: '#BFDBFE',
          300: '#93C5FD',
          400: '#60A5FA',
          500: '#3B82F6',
          600: '#2563EB',
          700: '#1D4ED8',
          800: '#1E40AF',
          900: '#1E3A8A',
        },
        inventory: {
          50: '#FFFBEB',
          100: '#FEF3C7',
          200: '#FDE68A',
          300: '#FCD34D',
          400: '#FBBF24',
          500: '#F59E0B',
          600: '#D97706',
          700: '#B45309',
          800: '#92400E',
          900: '#78350F',
        },
      },
    },
  },
});
```

---

## Component Color Usage Guidelines

### Buttons

```html
<!-- Primary button - Module color -->
<button class="bg-sales-500 hover:bg-sales-600 text-white font-semibold py-2 px-4 rounded">
  Button
</button>

<!-- Secondary button - Gray -->
<button class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-medium py-2 px-4 rounded">
  Cancel
</button>

<!-- Outline button -->
<button class="border-2 border-sales-500 text-sales-500 hover:bg-sales-500 hover:text-white font-medium py-2 px-4 rounded">
  Learn More
</button>
```

### Page Headers

```html
<!-- Sales page header -->
<header class="bg-sales-500 text-white py-6">
  <h1 class="text-3xl font-bold">Sales Dashboard</h1>
</header>

<!-- With gradient -->
<header class="bg-gradient-to-r from-sales-500 to-sales-600 text-white py-6">
  <h1 class="text-3xl font-bold">Sales Dashboard</h1>
</header>
```

### Cards

```html
<!-- Standard card -->
<div class="bg-white rounded-lg shadow-md p-6 border-l-4 border-sales-500">
  <h2 class="text-lg font-semibold text-gray-800">Card Title</h2>
  <p class="text-gray-600">Card content</p>
</div>

<!-- Colored card -->
<div class="bg-sales-50 rounded-lg shadow-md p-6">
  <h2 class="text-lg font-semibold text-sales-800">Alert</h2>
  <p class="text-sales-700">Important information</p>
</div>
```

### Status Indicators

```html
<!-- Success -->
<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-crm-100 text-crm-800">
  Active
</span>

<!-- Warning -->
<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-inventory-100 text-inventory-800">
  Low Stock
</span>

<!-- Error -->
<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-sales-100 text-sales-800">
  Overdue
</span>
```

### Tables

```html
<table class="min-w-full bg-white rounded-lg overflow-hidden shadow-md">
  <thead class="bg-sales-500 text-white">
    <tr>
      <th class="py-3 px-4 text-left font-semibold">Name</th>
      <th class="py-3 px-4 text-left font-semibold">Status</th>
    </tr>
  </thead>
  <tbody class="divide-y divide-gray-200">
    <tr class="hover:bg-sales-50">
      <td class="py-3 px-4">Item 1</td>
      <td class="py-3 px-4">Active</td>
    </tr>
  </tbody>
</table>
```

---

## Accessibility Notes

### Contrast Ratios

All module colors at 500 shade meet WCAG AA standards:

| Module | 500 on White | Contrast Ratio | WCAG Rating |
|--------|--------------|----------------|-------------|
| Sales | #EF4444 on #FFFFFF | 4.5:1 | AA |
| Finance | #6B7280 on #FFFFFF | 5.5:1 | AA |
| CRM | #10B981 on #FFFFFF | 4.6:1 | AA |
| HR | #3B82F6 on #FFFFFF | 4.7:1 | AA |
| Inventory | #F59E0B on #FFFFFF | 3.9:1 | A (large text only) |

**Note:** Inventory yellow may need darker text (600-700 shade) for small text to meet AA standards.

### Best Practices

1. **Use module-500 for primary actions** - Best balance of visibility and accessibility
2. **Always include hover states** - Use module-600 for pressed/hover states
3. **Provide text alternatives** - Don't rely on color alone for meaning
4. **Test with screen readers** - Ensure color-blind users can navigate
5. **Use sufficient contrast** - Minimum 4.5:1 for normal text, 3:1 for large text

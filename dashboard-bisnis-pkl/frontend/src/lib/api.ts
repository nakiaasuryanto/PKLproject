const API_BASE = import.meta.env.PUBLIC_API_URL || 'http://localhost:3001/api';

interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

interface RequestOptions {
  headers?: Record<string, string>;
  signal?: AbortSignal;
}

export async function fetchApi<T>(
  endpoint: string,
  options?: RequestInit & RequestOptions
): Promise<ApiResponse<T>> {
  try {
    const response = await fetch(`${API_BASE}${endpoint}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options?.headers,
      },
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      return {
        success: false,
        error: errorData.message || `HTTP ${response.status}: ${response.statusText}`,
      };
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('API Error:', error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error occurred',
    };
  }
}

// Convenience methods
export const api = {
  get: <T>(endpoint: string, options?: RequestOptions) =>
    fetchApi<T>(endpoint, { ...options, method: 'GET' }),

  post: <T>(endpoint: string, body: any, options?: RequestOptions) =>
    fetchApi<T>(endpoint, {
      method: 'POST',
      body: JSON.stringify(body),
      ...options,
    }),

  put: <T>(endpoint: string, body: any, options?: RequestOptions) =>
    fetchApi<T>(endpoint, {
      method: 'PUT',
      body: JSON.stringify(body),
      ...options,
    }),

  patch: <T>(endpoint: string, body: any, options?: RequestOptions) =>
    fetchApi<T>(endpoint, {
      method: 'PATCH',
      body: JSON.stringify(body),
      ...options,
    }),

  delete: <T>(endpoint: string, options?: RequestOptions) =>
    fetchApi<T>(endpoint, { ...options, method: 'DELETE' }),
};

// Typed API endpoints for each module
export const salesApi = {
  getOrders: () => api.get<any[]>('/sales/orders'),
  getOrder: (id: string) => api.get<any>(`/sales/orders/${id}`),
  createOrder: (data: any) => api.post<any>('/sales/orders', data),
  updateOrder: (id: string, data: any) => api.put<any>(`/sales/orders/${id}`, data),
  deleteOrder: (id: string) => api.delete<void>(`/sales/orders/${id}`),
  getProducts: () => api.get<any[]>('/sales/products'),
  getCustomers: () => api.get<any[]>('/sales/customers'),
  getStats: () => api.get<any>('/sales/stats'),
};

export const financeApi = {
  getTransactions: () => api.get<any[]>('/finance/transactions'),
  getTransaction: (id: string) => api.get<any>(`/finance/transactions/${id}`),
  createTransaction: (data: any) => api.post<any>('/finance/transactions', data),
  getInvoices: () => api.get<any[]>('/finance/invoices'),
  getInvoice: (id: string) => api.get<any>(`/finance/invoices/${id}`),
  getExpenses: () => api.get<any[]>('/finance/expenses'),
  getRevenue: () => api.get<any>('/finance/revenue'),
  getProfitLoss: () => api.get<any>('/finance/profit-loss'),
  getStats: () => api.get<any>('/finance/stats'),
};

export const inventoryApi = {
  getProducts: () => api.get<any[]>('/inventory/products'),
  getProduct: (id: string) => api.get<any>(`/inventory/products/${id}`),
  createProduct: (data: any) => api.post<any>('/inventory/products', data),
  updateProduct: (id: string, data: any) => api.put<any>(`/inventory/products/${id}`, data),
  deleteProduct: (id: string) => api.delete<void>(`/inventory/products/${id}`),
  getCategories: () => api.get<any[]>('/inventory/categories'),
  getSuppliers: () => api.get<any[]>('/inventory/suppliers'),
  getStockMovements: () => api.get<any[]>('/inventory/stock-movements'),
  getLowStock: () => api.get<any[]>('/inventory/low-stock'),
  getStats: () => api.get<any>('/inventory/stats'),
  getStock: (lowStock?: boolean) => api.get<any[]>(`/inventory/stock${lowStock ? '?low_stock=true' : ''}`),
  getMovements: (limit = 15) => api.get<any[]>(`/inventory/movements?limit=${limit}`),
  getLocations: () => api.get<any[]>('/inventory/locations'),
};

export const crmApi = {
  getContacts: () => api.get<any[]>('/crm/contacts'),
  getContact: (id: string) => api.get<any>(`/crm/contacts/${id}`),
  createContact: (data: any) => api.post<any>('/crm/contacts', data),
  updateContact: (id: string, data: any) => api.put<any>(`/crm/contacts/${id}`, data),
  deleteContact: (id: string) => api.delete<void>(`/crm/contacts/${id}`),
  getDeals: () => api.get<any[]>('/crm/deals'),
  getDeal: (id: string) => api.get<any>(`/crm/deals/${id}`),
  createDeal: (data: any) => api.post<any>('/crm/deals', data),
  updateDeal: (id: string, data: any) => api.put<any>(`/crm/deals/${id}`, data),
  getActivities: () => api.get<any[]>('/crm/activities'),
  getStats: () => api.get<any>('/crm/stats'),
};

export const hrApi = {
  getEmployees: () => api.get<any[]>('/hr/employees'),
  getEmployee: (id: string) => api.get<any>(`/hr/employees/${id}`),
  createEmployee: (data: any) => api.post<any>('/hr/employees', data),
  updateEmployee: (id: string, data: any) => api.put<any>(`/hr/employees/${id}`, data),
  deleteEmployee: (id: string) => api.delete<void>(`/hr/employees/${id}`),
  getAttendances: () => api.get<any[]>('/hr/attendances'),
  getPayroll: () => api.get<any[]>('/hr/payroll'),
  getDepartments: () => api.get<any[]>('/hr/departments'),
  getStats: () => api.get<any>('/hr/stats'),
};

export const dashboardApi = {
  getOverview: () => api.get<any>('/dashboard/overview'),
  getRecentActivities: () => api.get<any[]>('/dashboard/activities'),
  getNotifications: () => api.get<any[]>('/dashboard/notifications'),
};

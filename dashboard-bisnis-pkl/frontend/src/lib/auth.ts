// Auth utilities for client-side authentication

export interface User {
  id: number;
  username: string;
  name: string;
  email: string;
  role: 'admin' | 'it' | 'customer_service' | 'operations' | 'finance';
}

export interface Permissions {
  modules: string[];
  canViewSummary: boolean;
  canManageUsers: boolean;
}

export function getSessionId(): string | null {
  if (typeof window === 'undefined') return null;
  return localStorage.getItem('sessionId');
}

export function getUser(): User | null {
  if (typeof window === 'undefined') return null;
  const userStr = localStorage.getItem('user');
  if (!userStr) return null;
  try {
    return JSON.parse(userStr);
  } catch {
    return null;
  }
}

export function getPermissions(): Permissions | null {
  if (typeof window === 'undefined') return null;
  const permStr = localStorage.getItem('permissions');
  if (!permStr) return null;
  try {
    return JSON.parse(permStr);
  } catch {
    return null;
  }
}

export function isAuthenticated(): boolean {
  return !!getSessionId() && !!getUser();
}

export function hasModuleAccess(module: string): boolean {
  const permissions = getPermissions();
  if (!permissions) return false;
  return permissions.modules.includes(module);
}

export function canViewSummary(): boolean {
  const permissions = getPermissions();
  return permissions?.canViewSummary ?? false;
}

export function canManageUsers(): boolean {
  const permissions = getPermissions();
  return permissions?.canManageUsers ?? false;
}

export function logout(): void {
  localStorage.removeItem('sessionId');
  localStorage.removeItem('user');
  localStorage.removeItem('permissions');
  window.location.href = '/login';
}

export function getRoleName(role: string): string {
  const roleNames: Record<string, string> = {
    admin: 'Administrator',
    it: 'IT',
    customer_service: 'Customer Service',
    operations: 'Operations',
    finance: 'Finance'
  };
  return roleNames[role] || role;
}

export function getRoleColor(role: string): string {
  const roleColors: Record<string, string> = {
    admin: 'bg-blue-100 text-blue-800',
    it: 'bg-purple-100 text-purple-800',
    customer_service: 'bg-green-100 text-green-800',
    operations: 'bg-yellow-100 text-yellow-800',
    finance: 'bg-gray-100 text-gray-800'
  };
  return roleColors[role] || 'bg-gray-100 text-gray-800';
}

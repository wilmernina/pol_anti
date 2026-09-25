import { render, screen, cleanup } from '@testing-library/react';
import { afterEach, describe, expect, it, vi } from 'vitest';
import App from './App';
import { AuthProvider } from './auth/AuthContext';

afterEach(() => {
  cleanup();
  vi.unstubAllGlobals();
});

describe('App', () => {
  it('shows the authenticated portal login when there is no active user', () => {
    render(<AuthProvider><App /></AuthProvider>);
    expect(screen.getByText('Iniciar sesión')).toBeInTheDocument();
  });

  it('keeps the unauthenticated view even when the dashboard request resolves', () => {
    const fetch = vi.fn().mockResolvedValue({ json: async () => ({ success: false, data: [] }) });
    vi.stubGlobal('fetch', fetch);
    render(<AuthProvider><App /></AuthProvider>);
    expect(screen.getByText('Iniciar sesión')).toBeInTheDocument();
  });
});

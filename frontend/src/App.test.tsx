import { render, screen } from '@testing-library/react';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { cleanup } from '@testing-library/react';

import App from './App';

afterEach(() => {
  cleanup();
  vi.unstubAllGlobals();
});

describe('App', () => {
  it('shows the connection status returned by the API', async () => {
    vi.stubGlobal(
      'fetch',
      vi.fn().mockResolvedValue({
        ok: true,
        json: async () => ({ status: 'ok', database: 'connected' })
      })
    );

    render(<App />);

    expect(await screen.findByText('PostgreSQL conectado')).toBeInTheDocument();
  });

  it('shows a clear message when the API is unavailable', async () => {
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(new Error('network unavailable')));

    render(<App />);

    expect(await screen.findByText('No se pudo conectar con el backend')).toBeInTheDocument();
  });
});

import { render, screen, waitFor } from '@testing-library/react';
import { describe, expect, it, vi } from 'vitest';
import { PublicPortalPage } from './PublicPortalPage';

describe('PublicPortalPage', () => {
  it('muestra acceso al plan de acción, ejes y documento oficial', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({ json: async () => ({ success: true, data: [{ codigo: '1', nombre: 'Eje público', objetivo: 'Objetivo público' }] }) }));
    render(<PublicPortalPage />);
    expect(screen.getAllByRole('link', { name: /Plan de acción/i }).length).toBeGreaterThan(0);
    await waitFor(() => expect(screen.getByText('Eje público')).toBeInTheDocument());
    expect(screen.getByRole('link', { name: 'Ver documento PDF' })).toHaveAttribute('href', '/portal/politica-antidroga-2026-2030.pdf');
  });
});

import { cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { MatrizPlanificacion } from './MatrizPlanificacion';

afterEach(() => { cleanup(); vi.unstubAllGlobals(); });

describe('MatrizPlanificacion administrativa', () => {
  it('carga las acciones del eje y abre el formulario con las variables trimestrales', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ success: true, data: { acciones: [] }, error: null })
    }));

    render(<MatrizPlanificacion instituciones={[{ id: 1, siglas: 'CEO-FA', nombre: 'Comando Estratégico' }]} />);

    expect(await screen.findByText('Matriz de planificación')).toBeInTheDocument();
    fireEvent.click(screen.getByRole('button', { name: 'Nueva acción' }));

    expect(screen.getByLabelText('Acción a corto plazo')).toBeInTheDocument();
    expect(screen.getByLabelText('T1 (ENE-MAR)')).toBeInTheDocument();
    expect(screen.getByLabelText('T4 (OCT-DIC)')).toBeInTheDocument();
  });

  it('calcula Meta 2026 como suma de los cuatro trimestres', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ success: true, data: { acciones: [] }, error: null })
    }));

    render(<MatrizPlanificacion instituciones={[]} />);
    fireEvent.click(await screen.findByRole('button', { name: 'Nueva acción' }));
    fireEvent.change(screen.getByLabelText('T1 (ENE-MAR)'), { target: { value: '10' } });
    fireEvent.change(screen.getByLabelText('T2 (ABR-JUN)'), { target: { value: '20' } });
    fireEvent.change(screen.getByLabelText('T3 (JUL-SEP)'), { target: { value: '30' } });
    fireEvent.change(screen.getByLabelText('T4 (OCT-DIC)'), { target: { value: '40' } });

    await waitFor(() => expect(screen.getByLabelText('Meta 2026')).toHaveValue('100'));
  });
});

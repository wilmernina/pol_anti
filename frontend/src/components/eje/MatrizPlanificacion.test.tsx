import { cleanup, render, screen } from '@testing-library/react';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { MatrizPlanificacion } from './MatrizPlanificacion';

afterEach(cleanup);

const action = { codigo: '5.1', entidad: 'CEO-FA', nombre: 'Ejecutar operaciones de racionalización y erradicación', resultado: 'Operaciones ejecutadas', tipoAccion: 'RECURRENTE PROG.', unidadMedida: 'hectáreas', medios: 3, lineaBase: 42752, trimestres: [{ trimestre: 1, cantidadProgramada: 2500 }, { trimestre: 2, cantidadProgramada: 2500 }, { trimestre: 3, cantidadProgramada: 2500 }, { trimestre: 4, cantidadProgramada: 2500 }], meta2026: 10000, meta2030: 50000 };

describe('MatrizPlanificacion operativa', () => {
  it('muestra los grupos, variables y cuatro cantidades trimestrales', () => {
    render(<MatrizPlanificacion acciones={[action]} codigoEje="5" gestion={2026} />);

    expect(screen.getByText('IDENTIFICACIÓN INSTITUCIONAL')).toBeInTheDocument();
    expect(screen.getByText('DEFINICIÓN TÉCNICA DEL INDICADOR Y TRAZABILIDAD')).toBeInTheDocument();
    expect(screen.getByText('PROGRAMACIÓN PERIÓDICA GESTIÓN 2026 (TRIMESTRAL)')).toBeInTheDocument();
    expect(screen.getByText('CIERRE Y METAS GLOBALES')).toBeInTheDocument();
    expect(screen.getByText('T1 (ENE-MAR)')).toBeInTheDocument();
    expect(screen.getByText('T4 (OCT-DIC)')).toBeInTheDocument();
    expect(screen.getAllByText('2.500').length).toBe(4);
    expect(screen.getByText('10.000')).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Ficha' })).toBeInTheDocument();
  });

  it('permite desplazamiento horizontal en la tabla', () => {
    const { container } = render(<MatrizPlanificacion acciones={[action]} codigoEje="5" gestion={2026} />);
    expect(container.querySelector('.overflow-x-auto')).toBeInTheDocument();
  });

  it('envía la acción seleccionada al abrir la ficha', () => {
    const onFicha = vi.fn();
    render(<MatrizPlanificacion acciones={[action]} codigoEje="5" gestion={2026} onFicha={onFicha} />);
    screen.getByRole('button', { name: 'Ficha' }).click();
    expect(onFicha).toHaveBeenCalledWith(action);
  });

  it('envía la acción al abrir el registro de medición', () => {
    const onMedir = vi.fn();
    render(<MatrizPlanificacion acciones={[action]} codigoEje="5" gestion={2026} onMedir={onMedir} />);
    screen.getByRole('button', { name: 'Llenar medición' }).click();
    expect(onMedir).toHaveBeenCalledWith(action);
  });
});

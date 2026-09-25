import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { MatrizPlanificacionGestion } from './MatrizPlanificacionGestion';

const action = { codigo: '5.1', entidad: 'CEO-FA', nombre: 'Acción', resultado: 'Resultado', tipoAccion: 'PROYECTO', unidadMedida: 'número', medios: 1, lineaBase: 0, trimestres: [1, 2, 3, 4].map((trimestre) => ({ trimestre, cantidadProgramada: 10 })), meta2026: 40, metaGestion: 40, meta2030: 100 };

describe('MatrizPlanificacionGestion', () => {
  it('oculta Ficha para roles no administradores y muestra la gestión seleccionada', () => {
    render(<MatrizPlanificacionGestion acciones={[action]} codigoEje="5" gestion={2027} mostrarFicha={false} onMedir={() => undefined} />);
    expect(screen.queryByRole('button', { name: 'Ficha' })).not.toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Llenar medición' })).toBeInTheDocument();
    expect(screen.getByText('META 2027')).toBeInTheDocument();
  });
});

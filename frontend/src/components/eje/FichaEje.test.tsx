import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { FichaEje } from './FichaEje';

describe('FichaEje compacta', () => {
  it('mantiene el objetivo y organiza indicadores y resultados en secciones desplegables', () => {
    render(<FichaEje eje={{ objetivo: 'Objetivo del eje', indicadores_principales: 'Indicador uno;Indicador dos', resultados_2030: 'Resultado uno;Resultado dos' }} />);
    expect(screen.getByText('Objetivo del eje')).toBeInTheDocument();
    expect(screen.getByText(/Indicadores principales/)).toBeInTheDocument();
    expect(screen.getByText(/Resultados esperados 2030/)).toBeInTheDocument();
    expect(screen.getAllByRole('list')).toHaveLength(2);
  });
});

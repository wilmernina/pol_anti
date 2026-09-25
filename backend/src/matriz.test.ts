import { readFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';

const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');

describe('migración de matriz trimestral', () => {
  it('define los campos técnicos y la tabla trimestral con sus restricciones', async () => {
    const sql = await readFile(path.join(projectRoot, 'database/migrations/014_matriz_trimestral.sql'), 'utf8');

    expect(sql).toContain('linea_base NUMERIC');
    expect(sql).toContain('tipo_accion VARCHAR(30)');
    expect(sql).toContain('medio_verificacion TEXT');
    expect(sql).toContain('CREATE TABLE IF NOT EXISTS metas_trimestrales');
    expect(sql).toContain('trimestre INT NOT NULL CHECK (trimestre BETWEEN 1 AND 4)');
    expect(sql).toContain('cantidad_programada NUMERIC NOT NULL CHECK (cantidad_programada >= 0)');
    expect(sql).toContain('UNIQUE (accion_id, gestion, trimestre)');
  });
});

import { readFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import jwt from 'jsonwebtoken';
import request from 'supertest';
import type { Pool } from 'pg';
import { describe, expect, it, vi } from 'vitest';
import { createApp } from './app.js';
import { env } from './config/env.js';

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

const token = (rol: string) => jwt.sign({ id: 1, username: 'tester', rol, institucionId: null }, env.jwtSecret);

describe('API de matriz trimestral', () => {
  it('rechaza crear una acción sin token', async () => {
    const response = await request(createApp({ query: vi.fn() } as unknown as Pool))
      .post('/matriz/ejes/1/acciones')
      .send({});

    expect(response.status).toBe(401);
    expect(response.body.error).toBe('Token requerido');
  });

  it('rechaza crear una acción a un usuario que no es administrador', async () => {
    const response = await request(createApp({ query: vi.fn() } as unknown as Pool))
      .post('/matriz/ejes/1/acciones')
      .set('Authorization', `Bearer ${token('observador')}`)
      .send({});

    expect(response.status).toBe(403);
  });

  it('rechaza cantidades trimestrales negativas', async () => {
    const response = await request(createApp({ query: vi.fn() } as unknown as Pool))
      .post('/matriz/ejes/1/acciones')
      .set('Authorization', `Bearer ${token('admin')}`)
      .send({
        codigo: '1.99',
        entidadId: 1,
        nombre: 'Acción de prueba',
        resultado: 'Resultado de prueba',
        tipoAccion: 'PROYECTO',
        unidadMedida: 'número',
        trimestres: [10, -1, 0, 0]
      });

    expect(response.status).toBe(422);
    expect(response.body.error).toContain('negativas');
  });

  it('rechaza publicar una acción incompleta', async () => {
    const query = vi.fn().mockResolvedValue({ rows: [{ id: 10, unidad_medida: null, tipo_accion: null, trimestres: 0 }] });
    const response = await request(createApp({ query } as unknown as Pool))
      .post('/matriz/acciones/10/publicar')
      .set('Authorization', `Bearer ${token('admin')}`);

    expect(response.status).toBe(422);
  });

  it('devuelve los cuatro trimestres y la meta anual calculada', async () => {
    const query = vi.fn().mockResolvedValue({ rows: [{
      codigo: '1.1', entidad: 'DGFELCN', nombre: 'Acción publicada', resultado: 'Resultado', tipo_accion: 'PROYECTO', unidad_medida: 'número', medios: 2, linea_base: 0,
      t1: 10, t2: 20, t3: 30, t4: 40, meta_2026: 100, meta_2030: 200, estado_planificacion: 'publicada'
    }] });
    const response = await request(createApp({ query } as unknown as Pool)).get('/ejes/1/matriz');

    expect(response.status).toBe(200);
    expect(response.body.data.acciones[0].trimestres).toEqual([
      { trimestre: 1, cantidadProgramada: 10 },
      { trimestre: 2, cantidadProgramada: 20 },
      { trimestre: 3, cantidadProgramada: 30 },
      { trimestre: 4, cantidadProgramada: 40 }
    ]);
    expect(response.body.data.acciones[0].meta2026).toBe(100);
  });

  it('actualiza también la planificación trimestral al editar una acción', async () => {
    const clientQuery = vi.fn()
      .mockResolvedValueOnce({ rows: [{ id: 10 }] })
      .mockResolvedValueOnce({ rows: [{ id: 10, codigo: '1.1' }] })
      .mockResolvedValue({ rows: [] });
    const pool = { query: vi.fn(), connect: vi.fn().mockResolvedValue({ query: clientQuery, release: vi.fn() }) };
    const response = await request(createApp(pool as unknown as Pool))
      .put('/matriz/acciones/10')
      .set('Authorization', `Bearer ${token('admin')}`)
      .send({ ejeCodigo: '1', codigo: '1.1', entidadId: 1, nombre: 'Acción editada', resultado: 'Resultado', tipoAccion: 'PROYECTO', unidadMedida: 'número', trimestres: [1, 2, 3, 4] });

    expect(response.status).toBe(200);
    expect(clientQuery.mock.calls.some(([sql]) => String(sql).includes('metas_trimestrales'))).toBe(true);
  });
});

import request from 'supertest';
import { describe, expect, it, vi } from 'vitest';
import type { Pool } from 'pg';

import { createApp } from './app.js';

describe('GET /health', () => {
  it('returns PostgreSQL status when SELECT 1 succeeds', async () => {
    const query = vi.fn().mockResolvedValue({ rows: [{ ok: 1 }] });
    const response = await request(createApp({ query } as unknown as Pool)).get('/health');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ status: 'ok', database: 'connected' });
  });

  it('returns a safe unavailable status when PostgreSQL rejects the query', async () => {
    const query = vi.fn().mockRejectedValue(new Error('password=secret'));
    const response = await request(createApp({ query } as unknown as Pool)).get('/health');

    expect(response.status).toBe(503);
    expect(response.body).toEqual({ status: 'degraded', database: 'unavailable' });
  });
});

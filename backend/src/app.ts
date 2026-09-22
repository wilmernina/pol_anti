import express, { type Express } from 'express';
import cors from 'cors';
import type { Pool } from 'pg';

export function createApp(pool: Pool): Express {
  const app = express();

  app.use(cors());
  app.use(express.json());

  app.get('/health', async (_request, response) => {
    try {
      await pool.query('SELECT 1');
      response.status(200).json({ status: 'ok', database: 'connected' });
    } catch {
      response.status(503).json({ status: 'degraded', database: 'unavailable' });
    }
  });

  return app;
}

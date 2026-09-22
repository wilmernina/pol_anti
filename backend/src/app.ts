import express, { type Express } from 'express';
import cors from 'cors';
import type { Pool } from 'pg';
import { createEjesRouter } from './routes/ejesRoutes.js';
import { createReportesRouter } from './routes/reportesRoutes.js';
import { createAuthRouter } from './routes/authRoutes.js';
import { createResultadosCuatrimestralesRouter } from './routes/resultadosCuatrimestralesRoutes.js';
import { createAdminRouter } from './routes/adminRoutes.js';

export function createApp(pool: Pool): Express {
  const app = express();

  app.use(cors());
  app.use(express.json());
  app.use('/auth', createAuthRouter(pool));
  app.use('/admin', createAdminRouter(pool));
  // Vite removes the /api prefix before proxying requests to this server.
  app.use('/ejes', createEjesRouter(pool));
  app.use('/', createReportesRouter(pool));
  app.use('/', createResultadosCuatrimestralesRouter(pool));

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

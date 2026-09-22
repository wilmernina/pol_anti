import { Pool } from 'pg';
import { env } from '../config/env.js';
import { attachPoolErrorHandler } from './poolErrorHandler.js';

export const pool = new Pool({
  host: env.dbHost,
  port: env.dbPort,
  database: env.dbName,
  user: env.dbUser,
  password: env.dbPassword
});

attachPoolErrorHandler(pool, (message) => {
  console.error(message);
});

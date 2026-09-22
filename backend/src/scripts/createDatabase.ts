import { Client } from 'pg';
import { env } from '../config/env.js';

const client = new Client({
  host: env.dbHost,
  port: env.dbPort,
  database: 'postgres',
  user: env.dbUser,
  password: env.dbPassword
});

try {
  await client.connect();
  const exists = await client.query('SELECT 1 FROM pg_database WHERE datname = $1', [env.dbName]);

  if (exists.rowCount === 0) {
    await client.query(`CREATE DATABASE "${env.dbName.replaceAll('"', '""')}"`);
    console.log(`Database ${env.dbName} created.`);
  } else {
    console.log(`Database ${env.dbName} already exists.`);
  }
} finally {
  await client.end();
}

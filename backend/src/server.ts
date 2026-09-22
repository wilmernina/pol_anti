import { createApp } from './app.js';
import { env } from './config/env.js';
import { pool } from './db/pool.js';

const app = createApp(pool);

app.listen(env.apiPort, () => {
  console.log(`Backend listening on http://localhost:${env.apiPort}`);
});

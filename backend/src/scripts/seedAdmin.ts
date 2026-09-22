import bcrypt from 'bcrypt';
import { pool } from '../db/pool.js';
const hash=await bcrypt.hash('admin123',12);
await pool.query("INSERT INTO usuarios(username,password_hash,nombre_completo,rol) VALUES('admin',$1,'Administrador del sistema','admin') ON CONFLICT (username) DO NOTHING",[hash]);
await pool.end();

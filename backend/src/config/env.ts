import dotenv from 'dotenv';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const configDirectory = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.resolve(configDirectory, '../../.env') });

function required(name: string): string {
  const value = process.env[name]?.trim();
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

function positiveInteger(name: string, value: string): number {
  const numberValue = Number(value);
  if (!Number.isInteger(numberValue) || numberValue <= 0) {
    throw new Error(`Environment variable ${name} must be a positive integer`);
  }
  return numberValue;
}

export const env = {
  dbHost: required('DB_HOST'),
  dbPort: positiveInteger('DB_PORT', required('DB_PORT')),
  dbName: required('DB_NAME'),
  dbUser: required('DB_USER'),
  dbPassword: required('DB_PASSWORD'),
  apiPort: positiveInteger('API_PORT', required('API_PORT'))
};

import type { EventEmitter } from 'node:events';

type ErrorReporter = (message: string) => void;

export function attachPoolErrorHandler(pool: Pick<EventEmitter, 'on'>, reportError: ErrorReporter): void {
  pool.on('error', () => {
    reportError('PostgreSQL pool error');
  });
}

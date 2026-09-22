import { EventEmitter } from 'node:events';
import { describe, expect, it, vi } from 'vitest';

import { attachPoolErrorHandler } from './poolErrorHandler.js';

describe('attachPoolErrorHandler', () => {
  it('consumes idle client errors and reports a safe operational message', () => {
    const pool = new EventEmitter();
    const reportError = vi.fn();

    attachPoolErrorHandler(pool, reportError);

    expect(() => pool.emit('error', new Error('connection reset'))).not.toThrow();
    expect(reportError).toHaveBeenCalledWith('PostgreSQL pool error');
  });
});

import { useEffect, useState } from 'react';

type ConnectionState = 'loading' | 'connected' | 'unavailable';

export default function App() {
  const [connectionState, setConnectionState] = useState<ConnectionState>('loading');

  useEffect(() => {
    async function checkBackend() {
      try {
        const response = await fetch('/api/health');
        const body: unknown = await response.json();

        if (
          response.ok &&
          typeof body === 'object' &&
          body !== null &&
          (body as { status?: string; database?: string }).status === 'ok' &&
          (body as { database?: string }).database === 'connected'
        ) {
          setConnectionState('connected');
          return;
        }
      } catch {
        // The safe fallback is shown below for network and parsing failures.
      }

      setConnectionState('unavailable');
    }

    void checkBackend();
  }, []);

  const message = {
    loading: 'Verificando conexión con el backend…',
    connected: 'PostgreSQL conectado',
    unavailable: 'No se pudo conectar con el backend'
  }[connectionState];

  return (
    <main className="min-h-screen bg-slate-50 px-6 py-16 text-slate-900">
      <section className="mx-auto max-w-2xl rounded-xl bg-white p-8 shadow-sm ring-1 ring-slate-200">
        <p className="text-sm font-semibold uppercase tracking-wide text-emerald-700">Estado del sistema</p>
        <h1 className="mt-2 text-3xl font-bold">Política Antidroga 2026–2030</h1>
        <p className="mt-4 text-slate-600">Sistema de seguimiento y monitoreo del Plan de Acción por Eje.</p>
        <p
          className="mt-6 rounded-md bg-slate-100 px-4 py-3 font-medium"
          role="status"
          aria-live="polite"
        >
          {message}
        </p>
      </section>
    </main>
  );
}

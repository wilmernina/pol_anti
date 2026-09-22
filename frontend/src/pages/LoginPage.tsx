import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { useAuth } from '../auth/AuthContext';

type Credentials = { username: string; password: string };

export function LoginPage() {
  const { register, handleSubmit, formState: { errors } } = useForm<Credentials>();
  const { login } = useAuth();
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const submit = async (values: Credentials) => {
    setLoading(true); setError('');
    try {
      const response = await fetch('/api/auth/login', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(values) });
      const body = await response.json();
      if (!response.ok) throw new Error(body.error || 'Credenciales inválidas');
      login(body.data.user, body.data.token); window.location.href = '/';
    } catch (cause) { setError(cause instanceof Error ? cause.message : 'No se pudo iniciar sesión'); } finally { setLoading(false); }
  };

  return <main style={{ display: 'flex', minHeight: '100vh', width: '100%', alignItems: 'center', justifyContent: 'center' }} className="bg-slate-200 px-4 py-6 sm:px-6">
    <section style={{ margin: '0 auto', width: '100%' }} className="max-w-md rounded-2xl border border-slate-300 bg-white shadow-xl">
      <div className="rounded-t-2xl border-b border-emerald-100 bg-emerald-50 px-5 py-7 text-center sm:px-8">
        <img src="/branding/imagotipo-viceministerio.png" alt="Imagotipo del Viceministerio" className="mx-auto h-32 w-auto max-w-[220px] object-contain sm:h-36" />
        <p className="mt-5 text-xs font-bold uppercase tracking-[0.2em] text-emerald-700">Portal institucional</p>
        <h1 className="mt-2 text-xl font-bold text-slate-800 sm:text-2xl">Política Antidroga 2026–2030</h1>
        <p className="mt-1 text-sm text-slate-500">Sistema de seguimiento y monitoreo</p>
      </div>
      <div className="px-5 py-7 sm:px-8 sm:py-8">
        <div className="mb-6"><h2 className="text-2xl font-bold text-slate-800">Iniciar sesión</h2><p className="mt-1 text-sm text-slate-500">Ingrese sus credenciales institucionales.</p></div>
        <form onSubmit={handleSubmit(submit)} className="space-y-5">
          <label className="block text-sm font-semibold text-slate-700">Usuario<input autoComplete="username" className="mt-2 w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-3 text-base outline-none focus:border-emerald-500 focus:bg-white focus:ring-4 focus:ring-emerald-100" placeholder="Ingrese su usuario" {...register('username', { required: 'Ingrese su usuario' })} />{errors.username && <span className="mt-1 block text-xs text-red-600">{errors.username.message}</span>}</label>
          <label className="block text-sm font-semibold text-slate-700">Contraseña<input autoComplete="current-password" type="password" className="mt-2 w-full rounded-lg border border-slate-300 bg-slate-50 px-4 py-3 text-base outline-none focus:border-emerald-500 focus:bg-white focus:ring-4 focus:ring-emerald-100" placeholder="Ingrese su contraseña" {...register('password', { required: 'Ingrese su contraseña' })} />{errors.password && <span className="mt-1 block text-xs text-red-600">{errors.password.message}</span>}</label>
          {error && <p className="rounded-lg border border-red-200 bg-red-50 p-3 text-sm text-red-700" role="alert">{error}</p>}
          <button disabled={loading} className="w-full rounded-lg bg-emerald-600 py-3.5 text-base font-bold text-white shadow-sm transition hover:bg-emerald-700 disabled:cursor-wait disabled:opacity-60">{loading ? 'Validando acceso...' : 'Ingresar al portal'}</button>
        </form>
        <div className="mt-7 border-t border-slate-200 pt-5 text-center text-xs text-slate-400"><p>Acceso exclusivo para usuarios autorizados</p><p className="mt-1">Estado Plurinacional de Bolivia</p></div>
      </div>
    </section>
  </main>;
}

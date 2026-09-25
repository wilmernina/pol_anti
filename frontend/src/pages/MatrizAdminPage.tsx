import { useEffect, useState } from 'react';
import { PortalLayout } from '../components/PortalLayout';
import { MatrizPlanificacion } from '../components/admin/MatrizPlanificacion';

type Institution = { id: number; siglas: string; nombre: string };

export function MatrizAdminPage() {
  const [institutions, setInstitutions] = useState<Institution[]>([]);
  useEffect(() => { fetch('/api/admin/instituciones', { headers: { Authorization: `Bearer ${localStorage.getItem('token') || ''}` } }).then((response) => response.json()).then((body) => body.success && setInstitutions(body.data)); }, []);
  return <PortalLayout><main><div className="mb-6"><p className="text-sm font-semibold uppercase tracking-wide text-emerald-700">Administración</p><h1 className="mt-1 text-3xl font-bold">Matriz de planificación</h1><p className="mt-1 text-slate-500">Configuración trimestral de acciones para los nueve ejes.</p></div><MatrizPlanificacion instituciones={institutions} /></main></PortalLayout>;
}

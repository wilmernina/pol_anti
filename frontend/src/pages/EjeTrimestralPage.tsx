import { useEffect, useState } from 'react';
import { PortalLayout } from '../components/PortalLayout';
import { FichaEje } from '../components/eje/FichaEje';
import { MatrizPlanificacion, type MatrixAction } from '../components/eje/MatrizPlanificacion';

type Eje = { codigo: string; nombre: string; objetivo: string; indicadores_principales: string; resultados_2030: string };

export function EjeTrimestralPage({ codigo }: { codigo: string }) {
  const [eje, setEje] = useState<Eje>(); const [acciones, setAcciones] = useState<MatrixAction[]>([]); const [error, setError] = useState('');
  useEffect(() => { Promise.all([fetch(`/api/ejes/${codigo}/resumen`), fetch(`/api/ejes/${codigo}/matriz`)]).then(async ([summary, matrix]) => { const summaryBody = await summary.json(); const matrixBody = await matrix.json(); if (!summary.ok || !matrix.ok) throw new Error(summaryBody.error || matrixBody.error || 'No se pudo cargar el eje'); setEje(summaryBody.data); setAcciones(matrixBody.data.acciones.map((item: any) => ({ codigo: item.codigo, entidad: item.entidad, nombre: item.nombre, resultado: item.resultado, tipoAccion: item.tipo_accion, unidadMedida: item.unidad_medida || '', medios: item.medios || (item.medio_verificacion ? 1 : 0), lineaBase: item.linea_base, trimestres: item.trimestres, meta2026: item.meta2026, meta2030: item.meta_2030 }))); }).catch((reason) => setError(reason instanceof Error ? reason.message : 'No se pudo cargar el eje')); }, [codigo]);
  if (error) return <PortalLayout><main className="rounded-xl bg-white p-6 text-red-700">{error}</main></PortalLayout>;
  if (!eje) return <PortalLayout><main className="rounded-xl bg-white p-6">Cargando matriz…</main></PortalLayout>;
  return <PortalLayout><div className="mb-5"><p className="text-xs font-semibold uppercase tracking-wide text-blue-700">Estructura matricial oficial · Eje {codigo}</p><h1 className="mt-1 text-3xl font-bold">{eje.nombre}</h1><p className="mt-1 text-slate-500">Programación y seguimiento físico trimestral 2026.</p></div><FichaEje eje={eje} /><section className="mt-5"><div className="mb-3 flex items-center justify-between"><h2 className="text-xl font-bold">Matriz de planificación</h2><span className="rounded-full bg-blue-100 px-3 py-1 text-xs font-semibold text-blue-700">Visualizando: {acciones.length} registros</span></div><MatrizPlanificacion acciones={acciones} codigoEje={codigo} gestion={2026} /></section></PortalLayout>;
}

export function QuarterCell({ cantidadProgramada, unidadMedida }: { cantidadProgramada: number | null | undefined; unidadMedida: string }) {
  return <div className="min-h-16 rounded-lg bg-slate-50 px-2 py-2 text-center"><p className="font-bold text-slate-800">{cantidadProgramada === null || cantidadProgramada === undefined ? '—' : Number(cantidadProgramada).toLocaleString('es-BO')}</p><p className="text-[10px] uppercase text-slate-500">{unidadMedida}</p></div>;
}

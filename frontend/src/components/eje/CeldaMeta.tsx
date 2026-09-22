export function CeldaMeta({ programado, ejecutado, avance }: { programado:number|null; ejecutado:number; avance:number }) {
 const color=avance>=80?'bg-emerald-50 border-emerald-100':avance>=50?'bg-amber-50 border-amber-100':'bg-red-50 border-red-100';
 return <td title={`${avance.toFixed(1)}% de avance`} className={`min-w-[92px] border px-3 py-2 ${color}`}><div className="space-y-1 text-xs leading-tight"><div className="flex justify-between gap-2"><span className="text-slate-500">Prog.</span><strong>{programado ?? '—'}</strong></div><div className="flex justify-between gap-2"><span className="text-slate-500">Ejec.</span><strong>{ejecutado ?? 0}</strong></div></div></td>;
}

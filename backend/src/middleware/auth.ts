import type { NextFunction, Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { env } from '../config/env.js';

export type AuthUser = { id:number; username:string; rol:string; institucionId:number|null };
declare global { namespace Express { interface Request { user?: AuthUser } } }

export function verificarToken(req:Request,res:Response,next:NextFunction) {
 const token=req.header('authorization')?.replace(/^Bearer\s+/i,'');
 if(!token)return res.status(401).json({success:false,data:null,error:'Token requerido'});
 try { req.user=jwt.verify(token,env.jwtSecret) as AuthUser; next(); }
 catch { return res.status(401).json({success:false,data:null,error:'Token inválido o expirado'}); }
}
export const verificarRol=(...roles:string[]) => (req:Request,res:Response,next:NextFunction) => !req.user||!roles.includes(req.user.rol)?res.status(403).json({success:false,data:null,error:'Sin permiso'}):next();

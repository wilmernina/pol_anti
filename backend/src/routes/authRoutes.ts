import { Router } from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import type { Pool } from 'pg';
import { env } from '../config/env.js';
import { verificarToken, verificarRol } from '../middleware/auth.js';

const fail=(res:any,status:number,error:string)=>res.status(status).json({success:false,data:null,error});
export function createAuthRouter(pool:Pool):Router {
 const router=Router();
 router.post('/login',async(req,res)=>{const {username,password}=req.body??{};if(typeof username!=='string'||typeof password!=='string')return fail(res,400,'Usuario y contraseña requeridos');try{const q=await pool.query('SELECT u.id,u.username,u.password_hash,u.rol,u.institucion_id,i.siglas,i.nombre AS institucion FROM usuarios u LEFT JOIN instituciones i ON i.id=u.institucion_id WHERE u.username=$1 AND u.activo=true',[username]);const u=q.rows[0];if(!u||!(await bcrypt.compare(password,u.password_hash)))return fail(res,401,'Credenciales inválidas');const token=jwt.sign({id:u.id,username:u.username,rol:u.rol,institucionId:u.institucion_id},env.jwtSecret,{expiresIn:'8h'});return res.json({success:true,data:{token,user:{id:u.id,username:u.username,rol:u.rol,institucionId:u.institucion_id,institucion:u.institucion}},error:null});}catch{return fail(res,500,'No se pudo iniciar sesión');}});
 router.get('/me',verificarToken,async(req,res)=>res.json({success:true,data:req.user,error:null}));
 router.put('/profile',verificarToken,async(req,res)=>{const {nombre_completo,email,password}=req.body??{};if(typeof nombre_completo!=='string'||typeof email!=='string')return fail(res,400,'Nombre y correo son requeridos');try{const hash=typeof password==='string'&&password.length>=8?await bcrypt.hash(password,12):null;const q=await pool.query('UPDATE usuarios SET nombre_completo=$1,email=$2,password_hash=COALESCE($3,password_hash) WHERE id=$4 RETURNING id,username,nombre_completo,email,institucion_id,rol,activo',[nombre_completo,email,hash,req.user!.id]);if(!q.rows[0])return fail(res,404,'Usuario no encontrado');return res.json({success:true,data:q.rows[0],error:null});}catch{return fail(res,500,'No se pudo actualizar el perfil');}});
 router.post('/register',verificarToken,verificarRol('admin'),async(req,res)=>{const {username,password,nombre_completo,email,institucion_id,rol}=req.body??{};if(!username||!password||!rol)return fail(res,400,'Datos requeridos');try{const hash=await bcrypt.hash(password,12);const q=await pool.query('INSERT INTO usuarios(username,password_hash,nombre_completo,email,institucion_id,rol) VALUES($1,$2,$3,$4,$5,$6) RETURNING id,username,rol',[username,hash,nombre_completo||null,email||null,institucion_id||null,rol]);return res.status(201).json({success:true,data:q.rows[0],error:null});}catch{return fail(res,400,'No se pudo registrar usuario');}});
 return router;
}

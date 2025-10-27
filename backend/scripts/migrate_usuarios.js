#!/usr/bin/env node
/*
  migrate_usuarios.js

  Script to extract legacy users from the MariaDB `alumnos` database
  and insert them into the main Postgres `users` table using Prisma.

  Behavior:
  - Connects to MariaDB via ALUMNOS_DATABASE_URL and looks for a table named
    `usuarios` (case-insensitive). If not found it lists candidate tables and exits.
  - For each legacy user it will attempt to map fields (email, nombre, password).
  - Creates a user in Postgres using Prisma with a generated temporary password
    (bcrypt hashed) and provider set to "legacy". It writes a mapping file
    `backend/data/legacy_user_map.json` with objects { legacyId, newUserId, email, tempPassword }.

  IMPORTANT: Run this in a safe dev/staging environment first. Do not run
  against production without backups. The script assumes `@prisma/client` is
  generated and `DATABASE_URL` and `ALUMNOS_DATABASE_URL` are set in env.
*/

import dotenv from 'dotenv';
import mysql from 'mysql2/promise';
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';
import crypto from 'crypto';
import fs from 'fs';
import path from 'path';

dotenv.config({ path: path.resolve(process.cwd(), '../.env') }); // try backend/.env if present

const ALUMNOS_URL = process.env.ALUMNOS_DATABASE_URL;
if (!ALUMNOS_URL) {
  console.error('ALUMNOS_DATABASE_URL is not set. Set it in environment or backend/.env');
  process.exit(1);
}

const args = process.argv.slice(2);
const DRY_RUN = args.includes('--dry-run') || args.includes('-n');
let prisma = null;
if (!DRY_RUN) prisma = new PrismaClient();

async function findUsuariosTable(conn) {
  const [rows] = await conn.query("SHOW TABLES");
  const tables = rows.map(r => Object.values(r)[0].toLowerCase());
  if (tables.includes('usuarios')) return 'usuarios';
  // common alternatives
  for (const t of ['users','usuario','admins','lideres_familia','lideres']) {
    if (tables.includes(t)) return t;
  }
  return null;
}

function normalizeName(full) {
  if (!full) return { names: '', lastName: '' };
  const parts = full.trim().split(/\s+/);
  if (parts.length === 1) return { names: parts[0], lastName: '' };
  return { names: parts.slice(0, -1).join(' '), lastName: parts.slice(-1)[0] };
}

async function main() {
  const conn = await mysql.createConnection(ALUMNOS_URL);
  try {
    const usuariosTable = await findUsuariosTable(conn);
    if (!usuariosTable) {
      console.error('No `usuarios`-like table found in alumnos DB. Available tables:');
      const [rows] = await conn.query('SHOW TABLES');
      console.log(rows.map(r => Object.values(r)[0]).join('\n'));
      process.exit(2);
    }

  console.log('Found users table:', usuariosTable);
  const [users] = await conn.query(`SELECT * FROM \`${usuariosTable}\``);
    console.log(`Found ${users.length} legacy users.`);

    const mapping = [];
    for (const legacy of users) {
      // Detect common column names
      const legacyId = legacy.id ?? legacy.userId ?? legacy.usuario_id ?? legacy.usuarioid ?? legacy.userid ?? legacy.ID ?? legacy.id_usuario;
      const rawEmail = legacy.email ?? legacy.correo ?? legacy.correo_institucional ?? legacy.email_usuario;
      const rawName = legacy.nombre ?? legacy.name ?? legacy.nombre_completo ?? `${legacy.firstName ?? ''} ${legacy.lastName ?? ''}`.trim();
      const rawPassword = legacy.password ?? legacy.clave ?? null;

      if (!rawEmail) {
        console.warn('Skipping legacy user without email:', legacyId);
        continue;
      }

      const { names, lastName } = normalizeName(rawName || rawEmail);

      // Generate temporary password (will be returned in mapping for admin to notify user)
      const tempPassword = crypto.randomBytes(8).toString('hex');
      const hashed = await bcrypt.hash(tempPassword, 10);

      if (DRY_RUN) {
        // Simulate creation: generate a predictable UUID for preview
        const predictedId = crypto.randomUUID ? crypto.randomUUID() : 'dry-' + String(legacyId || crypto.randomBytes(6).toString('hex'));
        mapping.push({ legacyId, newUserId: predictedId, email: rawEmail, tempPassword, dryRun: true, names, lastName });
        console.log(`[dry-run] Would import ${rawEmail} -> ${predictedId}`);
      } else {
        // Create user in Postgres using Prisma
        try {
          const created = await prisma.user.create({
            data: {
              email: rawEmail,
              password: hashed,
              names: names || rawEmail,
              lastName: lastName || null,
              role: 'STAFF',
              provider: 'legacy',
              emailVerified: false
            }
          });

          mapping.push({ legacyId, newUserId: created.id, email: rawEmail, tempPassword });
          console.log(`Imported ${rawEmail} -> ${created.id}`);
        } catch (err) {
          console.error('Failed to import', rawEmail, err.message || err);
          mapping.push({ legacyId, newUserId: null, email: rawEmail, error: String(err) });
        }
      }
    }

    // Write mapping to file
    const outDir = path.resolve(process.cwd(), '../data');
    try { fs.mkdirSync(outDir, { recursive: true }); } catch (e) {}
    const outFile = path.join(outDir, 'legacy_user_map.json');
    fs.writeFileSync(outFile, JSON.stringify(mapping, null, 2), 'utf8');
    console.log('Mapping written to', outFile);
    console.log('Done. Review mapping and notify users to reset passwords or enable Google SSO.');

  } finally {
    await prisma.$disconnect();
    await conn.end();
  }
}

main().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});

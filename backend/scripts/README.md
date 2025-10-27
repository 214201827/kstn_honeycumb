Migration scripts
=================

This folder contains helper scripts to migrate legacy data into the new Honeycumb backend.

migrate_usuarios.js
-------------------
- Purpose: Extract users from the legacy MariaDB `alumnos` database and create corresponding
  `users` in the PostgreSQL database used by Honeycumb. Produces `backend/data/legacy_user_map.json`.
- Usage:

  1. Set the environment variables in `backend/.env` or export them in your shell:

     ALUMNOS_DATABASE_URL=mysql://user:pass@host:3306/ALUMNOS_KEYSTONE
     DATABASE_URL=postgresql://user:pass@host:5432/honeycumb

  2. Install dependencies and generate Prisma client if needed:

     cd backend
     npm install
     npx prisma generate

  3. Run the script (from repo root):

     node backend/scripts/migrate_usuarios.js

Dry-run
-------
If you want to preview the mapping without creating users in Postgres, run with the `--dry-run` (or `-n`) flag. This will generate `backend/data/legacy_user_map.json` with a predicted `newUserId` and temporary passwords, but it will not modify the Postgres DB.

   node backend/scripts/migrate_usuarios.js --dry-run

Notes
-----
- The script tries to find a table named `usuarios` (case-insensitive). If not found it will search for common alternatives and print available tables.
- The script creates users with a temporary password (included in the mapping output). You should force a password reset or switch to Google SSO for these accounts.
- Test this in a staging environment before running in production.

Honeycumb — Backend (scaffold)

Este directorio contiene el scaffold inicial para la reingeniería del backend usando Fastify y Prisma.

Requisitos:
- Node.js 20+
- PostgreSQL
- yarn o npm

Instalación rápida:

```bash
cd backend
npm install
cp .env.example .env
# Editar .env con tu DATABASE_URL y JWT_SECRET
npx prisma generate
npm run dev
```

Siguientes pasos:
- Implementar migraciones con `npx prisma migrate dev --name init`.
- Implementar endpoints (auth, students, credentials, reports).
- Implementar HMAC para QR y endpoint `/verify/:credentialNumber`.

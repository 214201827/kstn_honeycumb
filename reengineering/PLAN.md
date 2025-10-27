Plan de limpieza y reingeniería — Honeycumb

Objetivo
-------
Limpiar el repositorio legacy, crear un scaffold moderno y comenzar la reescritura del sistema como "Honeycumb" (SIS + credencialización física). Mantener el código anterior en un área `legacy/` para referencia.

Fases propuestas
---------------
1. Snapshot y resguardo (manual o con git):
   - Crear una rama `legacy-snapshot` desde la rama actual y push al remoto.
   - (Opcional) Etiquetar la versión legacy: `git tag legacy-v1`.

2. Mover código legacy a carpeta `legacy/` (opcional manual):
   - Mover carpetas: `node/`, `node.bak/`, `node.bak2/`, `db/` (si se desea conservar los SQL), etc. a `legacy/`.
   - Actualizar `README.md` para señalar donde está el código legacy.

3. Crear ramas principales:
   - `main` — Producción
   - `develop` — Integración diaria
   - `feature/*` — Nuevas características
   - `legacy/*` — Parches menores sobre la base legacy (si necesario)

4. Scaffold del nuevo stack:
   - Frontend: `frontend/` — Next.js + Tailwind
   - Backend: `backend/` — Fastify + Prisma + PostgreSQL
   - Shared: `shared/` — tipos y utilidades

5. Migración de base de datos:
   - Diseñar nuevo esquema en `backend/prisma/schema.prisma`.
   - Crear migraciones iniciales y scripts de seed.
   - Plan de migración de datos desde MySQL (si se requiere): escribir scripts ETL que exporten datos desde tablas legacy y mapeen a nuevas estructuras (normalización de nombres, UUIDs, validación de emails, fotos).

6. Implementación incremental:
   - Priorizar funcionalidades mínimas: auth (users), CRUD students, generación de credenciales (QR/HMAC), verificación pública.
   - Añadir pruebas unitarias e integración.

7. Infraestructura y CI/CD:
   - GitHub Actions para pruebas y deploy.
   - Docker Compose para orquestación local (Postgres, Redis, backend, frontend).
   - Configurar S3 (o MinIO) para storage de fotos y PDFs.

8. Migración y rollout:
   - Probar migraciones en staging.
   - Validación con muestras de datos.
   - Plan de rollback en caso de fallos.

Notas operativas
----------------
- Cualquier cambio que mueva o borre archivos legacy debe realizarse en una rama específica y con aprobación (PR) para evitar pérdida accidental.
- Si quieres que realice la migración automática de archivos a `legacy/` puedo hacerlo, pero necesitaré tu confirmación explícita (es una operación destructiva a nivel de estructura de repo).

Tareas inmediatas que implementé ya:
- Scaffold de backend inicial en `backend/` (Fastify + Prisma schema)
- Documentación del plan aquí en `reengineering/PLAN.md`

Siguientes acciones recomendadas (manuales o automatizables):
- ¿Mover carpetas legacy a `legacy/` ahora? (si confirmas, lo ejecuto)
- Crear rama `develop` y configurar CI básico (tests -> build -> deploy to staging)
- Empezar a implementar endpoints prioritarios (auth + verify + students)


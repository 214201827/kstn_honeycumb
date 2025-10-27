# Plan de limpieza y reingeniería — Honeycumb

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

5. Migración y bases de datos:
   - Base de datos principal (PostgreSQL):
     - Diseñar nuevo esquema en `backend/prisma/schema.prisma`.
     - Crear migraciones iniciales y scripts de seed.
     - Multi-tenant: un tenant por plantel, con subdominio propio.
   - Base administrativa `alumnos` (MariaDB):
     - Mantener conexión a la base existente en MariaDB 11.8.
     - Usar `backend/prisma/alumnos.prisma` para acceso a datos.
     - No modificar su estructura — es fuente autoritativa para datos de estudiantes.
   - Estrategia de sincronización:
     - Crear un servicio que mantenga los datos de estudiantes sincronizados desde `alumnos` hacia el nuevo sistema.
     - Los datos de Google Classroom y actividades personalizadas se almacenan solo en PostgreSQL.
     - Plan de rollback: mantener logs de sincronización y checksums.

6. Implementación incremental:
   - Priorizar funcionalidades mínimas:
     1. Auth (users) + integración Google Workspace
     2. Sync desde DB `alumnos` + CRUD students
     3. Generación de credenciales (QR/HMAC)
     4. Verificación pública
     5. Integración con Google Classroom

7. Infraestructura y CI/CD:
   - GitHub Actions para pruebas y deploy.
   - Docker Compose para orquestación local:
     - PostgreSQL (datos principales)
     - MariaDB (conexión a `alumnos` existente)
     - Redis (cache, rate limiting)
     - Backend (Fastify + workers)
     - Frontend (Next.js)
   - Configurar S3 (o MinIO) para storage de fotos y PDFs.

8. Migración y rollout:
   - Probar migraciones en staging.
   - Validación con muestras de datos.
   - Plan de rollback en caso de fallos.

Bases de datos y sincronización
-----------------------------
1. MariaDB `alumnos` (11.8):
   - Base existente con datos administrativos de estudiantes
   - Se accede mediante `backend/prisma/alumnos.prisma`
   - NO se modifica su estructura
   - Se lee periódicamente para mantener datos sync

2. PostgreSQL principal:
   - Nueva base para el SIS
   - Multi-tenant (un tenant = un plantel)
   - Almacena:
     - Usuarios y roles
     - Credenciales
     - Actividades (Google Classroom + manuales)
     - Calificaciones y asistencia
     - Configuración por tenant

3. Flujo de datos:
   ```
   MariaDB alumnos     →  Servicio sync  →  PostgreSQL
   (fuente de verdad     (workers/jobs)     (sistema SIS)
    para estudiantes)                       
   ```

Notas operativas
----------------
- Cualquier cambio que mueva o borre archivos legacy debe realizarse en una rama específica y con aprobación (PR) para evitar pérdida accidental.
- La base `alumnos` es READ-ONLY desde la perspectiva de Honeycumb.
- Logs detallados de sincronización para debugging y auditoría.

Estado actual
------------
- ✓ Scaffold de backend inicial en `backend/` (Fastify + Prisma schema)
- ✓ Documentación del plan aquí en `reengineering/PLAN.md`
- ✓ Esquema Prisma para ambas bases de datos
- ✓ Archivado de código legacy en `legacy/`

Siguientes acciones recomendadas:
1. Configurar CI/CD y protección de ramas
2. Implementar servicio de sincronización `alumnos`→PostgreSQL
3. Empezar endpoints prioritarios (auth + verify)


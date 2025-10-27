# Integración con Google Workspace for Education (Honeycumb)

Este documento describe los requisitos funcionales (RF) adicionales solicitados por el proyecto y las implicaciones técnicas derivadas para implementar integración con Google Workspace for Education, sincronización con Google Classroom, subdominios por tipo de cuenta, multi-plantel, backups y actividades personalizadas por docente.

## Resumen de RF añadidos

- Integración con Google Workspace for Education:
  - Los reportes de calificaciones podrán (opcionalmente) alimentarse a partir de Google Classroom.
  - Los docentes podrán registrarse/identificarse usando su cuenta del Workspace (OAuth2 / SSO).
  - Las familias podrán acceder a un portal para consultar reportes y solicitar documentos.
  - El sistema debe soportar verificación de dominio y permisos administrativos (consentimiento del administrador del Workspace).

- Subdominios por tipo de cuenta:
  - Familias: `families.<school-domain>` (ej.: `families.school.edu.mx`)
  - Personal de la escuela (docentes, coordinadores, admin): `school.<school-domain>` (ej.: `school.edu.mx`)
  - Estudiantes: `students.<school-domain>` (ej.: `students.school.edu.mx`)
  - Requisitos: DNS, certificados (wildcard) y separación de UI (o routes) por dominio.

- Actividades personalizadas:
  - Los maestros podrán crear actividades manuales (título, descripción, fecha, peso, rúbrica, archivo adjunto).
  - Estas actividades se integran en los reportes y en el cálculo de promedios junto con lo que venga de Google Classroom.

- Tipos de usuario (RBAC inicial):
  - Administrador
  - Coordinador
  - Maestro
  - Líder de familia
  - (Futuro) Alumno — diseño preparado para añadirlo posteriormente

- Backups automatizados:
  - Backups diarios (o configurables) de la base de datos, con retención configurables y almacenamiento seguro (S3 compatible o almacenamiento local con cifrado).
  - Scripts de restauración y pruebas de integridad automatizadas.

- Multi-plantel:
  - El sistema podrá ser multi-plantel (tenant): varias escuelas con separación lógica de datos, y posibilidad de desplegar subdominios por plantel.

## Implicaciones arquitectónicas y decisiones recomendadas

1. Identidad y autenticación
   - Usar un servicio de autenticación central (ej. Auth server con OpenID Connect) que gestione proveedores externos (Google OAuth2) y credenciales locales.
   - Autenticación primaria para docentes: OAuth2 con Google Workspace. Para familias (si no pertenecen al Workspace) proveer registro local o SSO via Google (si se desea).
   - Para multi-subdominio y sesión: emitir cookies con dominio raíz (`.school.edu.mx`) o usar tokens (JWT) y un dominio de autorización central (auth.school.edu.mx). Asegurar configuración segura de cookies (SameSite, Secure, HttpOnly).
   - Documentar el flujo de consentimiento: el administrador del Workspace tendrá que autorizar scopes de Google Classroom / Admin SDK para que la app acceda a datos.

2. Google Classroom & sincronización
   - Hay dos opciones de integración:
     - a) Servicio con cuentas de usuario y OAuth2: cada docente autoriza acceso a sus cursos (scopes de Classroom). Ideal para modelos simples.
     - b) Integración de cuenta de servicio con Domain-Wide Delegation (DWD): permite que la aplicación lea datos de Classroom a nivel de dominio (requiere configuración del administrador del Workspace). Recomendado para sincronizaciones administrativas o masivas.
   - Scopes mínimos sugeridos: `https://www.googleapis.com/auth/classroom.courses.readonly`, `.../coursework.me`, `.../students.readonly`, y `openid email profile` para login.
   - Diseñar un job de sincronización (background worker) que:
     - Consulte cursos y tareas en Classroom
     - Mapée los cursos de Classroom a `Course` en la DB
     - Cree/actualice `Student` y `Enrollment` vinculado (buscar por email / studentId)
     - Cree/actualice `Activity`/`GradeItem` y grades; marcar origen (Classroom vs manual)
     - Mantenga un historial de importación (`ImportJob` / `ImportLog`) y permita re-run y reconciliación manual.

## Modelado de datos y estrategia multi-base

### Base de datos administrativa (MariaDB)
- Base `alumnos` (MariaDB 11.8):
  - Fuente autoritativa para datos administrativos de estudiantes
  - Acceso READ-ONLY mediante `backend/prisma/alumnos.prisma`
  - Los datos se sincronizan unidireccionalmente hacia PostgreSQL
  - Ver `db/alumnos/` para el esquema y estructura

### Base de datos principal (PostgreSQL)
- Esquema en `backend/prisma/schema.prisma`
- Modelos adicionales:
  - `Tenant` o `School` (id, name, domain, config) para multi-plantel
  - `User` → añadir `tenantId`, `role`, `googleId`, `emailVerified`, `provider`
  - `Activity` / `GradeItem` con campos: source (classroom/manual), externalId, weight, maxScore, rubric (json), attachments
  - `ImportJob` y `ImportLog` para trazabilidad de sincronizaciones (tanto de `alumnos` como de Google Classroom)
  - `Subdomain` o configuración de `Tenant` para definir subdominios y certificados

### Flujo de datos y sincronización
1. MariaDB → PostgreSQL:
   - Worker dedicado sincroniza datos de estudiantes
   - Detecta cambios mediante timestamps o checksums
   - Mantiene mapeo de IDs entre sistemas
2. Google Classroom → PostgreSQL:
   - Worker separado para importar datos de Classroom
   - Vincula estudiantes usando emails como clave
   - Registra todo en `ImportJob`/`ImportLog`

4. Subdominios y despliegue
   - Requerimientos al equipo de TI de la escuela:
     - Añadir registros DNS (A/ALIAS) para `*.school.edu.mx` o configurar subdominios específicos.
     - Obtener certificados TLS (Let's Encrypt wildcard o certificados provisionados) — automatizar con Cert-Manager si se usa Kubernetes.
   - El servidor debe soportar virtual hosts o routing por `Host` header y enrutar a la UI adecuada.
   - Considerar separación UI por subdominio (diseño y textos) pero compartir el mismo backend (auth centralizada).

5. Backups y restauración
   - Implementar cronjobs o jobs en container/infra que ejecuten:
     - `pg_dump --format=custom` con compresión y encriptación antes de subir a storage seguro.
     - Rotación/retención: 7/30/90 días según configuración.
     - Prueba de restauración periódica (sandbox) para comprobar integridad del backup.
   - Registrar metadatos de backup (manifest) con timestamp, checksum, size, y archivo de logs.

6. Privacidad y cumplimiento
   - Documentar qué datos se sincronizan desde Google Classroom y obtener consentimiento claro.
   - Minimizar datos importados: almacenar sólo lo necesario para reportes (emails, nombres, calificaciones) y evitar datos sensibles salvo necesario.
   - Añadir registro de auditoría para acceso y acciones sobre datos personales y grades.

7. Interfaz y experiencia de reportes
   - El generador de reportes debe poder combinar:
     - Items importados desde Classroom
     - Items añadidos manualmente por docentes
   - Permitir que maestros configuren pesos y rúbricas para actividades manuales.
   - Portal de familias: acceso read-only a reportes y un flujo para solicitar documentos (genera ticket que el admin/coordinador atiende).

8. Operación y SRE
   - Monitorización de jobs de sincronización (errores, latencias, quotas de API Google).
   - Rate limiting y retries con backoff para llamadas a Google APIs.
   - Logs centralizados y alertas (por ejemplo, integración con Sentry / Prometheus + alertmanager).

## Requisitos no funcionales derivados

- Autorización: RBAC por tenant; separación de permisos para ver/editar notas y actividades.
- Escalabilidad: la sincronización puede ser intensiva; externalizar workers (Redis queue, sidekicks) y límites por tenant.
- Disponibilidad: RTO/RPO definidos en la política de backups (ej.: RTO < 2 horas, RPO < 24h) — configurable por tenant.
- Seguridad: cifrado en tránsito y reposo para backups y datos sensibles; rotación de claves API/secretos.

## Tareas técnicas recomendadas (priorizadas)

1. Añadir en Prisma los modelos: `Tenant`, `ImportJob`, `Activity` (source + externalId) y `User.tenantId`.
2. Implementar servicio de autenticación con soporte para Google OAuth2 (docentes) y registro local (familias).
3. Implementar job worker para sincronizar Classroom (modo inicial: DWD con cuenta de servicio o OAuth por docente según elección del cliente).
4. Implementar endpoints y UI para que maestros creen actividades manuales y las asocien a cursos.
5. Crear scripts y/o jobs de backup y documentación de restauración.
6. Documentar pasos de DNS, verificación de dominio y solicitud de consentimiento al admin del Workspace.

## Consideraciones para ser "forkeable"

- Mantener configuración por tenant en archivos (JSON/YAML) o en la base de datos para que cada escuela pueda adaptar su dominio, logo, calendarios y reglas de reporte sin tocar el código.
- Evitar hardcoding; exponer variables de entorno y/o UI de configuración.
- Proveer un `README` paso-a-paso para integrar Google Workspace (incluyendo enlaces a la consola Google Cloud, pasos para Domain-Wide Delegation, scopes necesarios y cómo instalar credenciales JSON en la app).

## Próximos pasos sugeridos

- Añadir a `backend/prisma/schema.prisma` los modelos sugeridos (Tenant, Activity, ImportJob) y ejecutar una migración de prueba.
- Implementar endpoints y pruebas E2E del flujo de importación (simular Classroom payloads con fixtures).
- Preparar una guía para el proveedor de IT de la escuela con los pasos DNS/SSL y la petición de consentimiento.

---

Documento generado para orientar la implementación de los RF solicitados. Si quieres, puedo:

- Añadir los cambios de modelo a `backend/prisma/schema.prisma` y generar la migración inicial; o
- Crear plantillas de scripts de backup (bash + docker-compose); o
- Implementar el scaffolding del servicio de sincronización (trabajador y endpoints de webhook/import).

Indícame cuál de estas opciones quieres que haga ahora.
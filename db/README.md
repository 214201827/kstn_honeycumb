# Database Scripts

Este directorio contiene los scripts SQL para la nueva versión del sistema Honeycumb.

## Estructura

- `school_system_upgrade.sql`: Script principal de migración que añade las tablas necesarias para el Sistema de Información Escolar (SIS) y el sistema de credencialización.

## Archivos Legacy

Los scripts históricos han sido movidos a `legacy/db/` para mantener el código limpio mientras se realiza la reingeniería. Incluyen:

- `courses.sql`, `studentCourses.sql`: Definiciones originales de cursos y asignaciones
- `ddl.sql`: Estructura original de la base de datos
- `inserts_prueba.sql`, `reset_data.sql`: Datos de prueba y scripts de reset
- `mariadb-image-docker-init.sql`: Inicialización del contenedor MariaDB
- `healthcheck.sh`: Script de verificación de estado de la DB

Para acceder a estos archivos, consultar el directorio `legacy/db/`. La historia git se ha preservado usando `git mv`.
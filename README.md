# Honeycumb

Sistema de Información Escolar y Credencialización digital — Honeycumb.

## Resumen

Honeycumb es la evolución del repositorio legacy `kstn_honeycumb`. Esta rama/versión contiene las mejoras y la reingeniería para convertir la herramienta en un Sistema de Información Escolar completo con soporte para credenciales físicas y generación de reportes.

Este repositorio mantiene el código legacy en la rama `legacy/*`. Las nuevas piezas/propuestas se desarrollarán en ramas `feature/*` y la integración continuará en `develop` y `main`.

## Documentación

La documentación principal se encuentra en la carpeta `doc/`:

- `doc/ARQUITECTURA.md` — Arquitectura propuesta
- `doc/DESARROLLO.md` — Guía de desarrollo
- `doc/USUARIO.md` — Manual de usuario
- `doc/API.md` — Referencia de la API
- `doc/IEEE_TEMPLATE.md` — Transcripción de `Plantilla_ERS_IEEE.pdf` (SRS template)
- `doc/CREDENTIALS_PHYSICAL.md` — Especificaciones para credenciales físicas

## Construcción y ejecución (legacy)

Si quieres ejecutar la versión legacy del proyecto usando Docker (método antiguo):

```bash
docker compose build
docker compose up -d
```

## Requisitos para la reingeniería (propuesta)

- Node.js 20+
- PostgreSQL 15+
- Redis 7+
- Docker & Docker Compose

## Contribuir

1. Fork y clone del repo
2. Crear rama `feature/<descripcion>`
3. Hacer commits claros y abrir PRs hacia `develop`

## Licencia

Mantiene la licencia original incluida en el repo. Revisa `LICENSE` para detalles sobre la licencia actual.

---

Última actualización: Octubre 2025

# API Reference

## Base URL
```
https://api.honeycumb.com/v1
```

## Autenticación

Todas las rutas de API requieren autenticación JWT excepto donde se indique lo contrario.

### Headers Requeridos
```http
Authorization: Bearer <token>
```

## Endpoints

### Autenticación

#### Login
```http
POST /auth/login
```

Body:
```json
{
  "email": "string",
  "password": "string"
}
```

Response:
```json
{
  "token": "string",
  "refreshToken": "string",
  "user": {
    "id": "string",
    "email": "string",
    "role": "string"
  }
}
```

### Estudiantes

#### Listar Estudiantes
```http
GET /students
```

Query Parameters:
```
page: number (default: 1)
limit: number (default: 10)
search: string
status: "active" | "inactive"
```

Response:
```json
{
  "data": [
    {
      "id": "string",
      "names": "string",
      "lastNames": "string",
      "email": "string",
      "status": "string",
      "createdAt": "string"
    }
  ],
  "pagination": {
    "total": "number",
    "pages": "number",
    "current": "number"
  }
}
```

#### Obtener Estudiante
```http
GET /students/{id}
```

Response:
```json
{
  "id": "string",
  "names": "string",
  "lastNames": "string",
  "email": "string",
  "dateOfBirth": "string",
  "gender": "string",
  "address": "string",
  "phoneNumber": "string",
  "emergencyContact": "string",
  "status": "string",
  "createdAt": "string",
  "updatedAt": "string"
}
```

#### Crear Estudiante
```http
POST /students
```

Body:
```json
{
  "names": "string",
  "lastNames": "string",
  "email": "string",
  "dateOfBirth": "string",
  "gender": "string",
  "address": "string",
  "phoneNumber": "string",
  "emergencyContact": "string"
}
```

### Credenciales

#### Generar Credencial
```http
POST /credentials
```

Body:
```json
{
  "studentId": "string",
  "type": "regular" | "temporary"
}
```

Response:
```json
{
  "id": "string",
  "number": "string",
  "qrCode": "string",
  "issuedAt": "string",
  "expiresAt": "string"
}
```

#### Verificar Credencial
```http
GET /credentials/verify/{number}
```
*No requiere autenticación*

Response:
```json
{
  "isValid": "boolean",
  "student": {
    "id": "string",
    "names": "string",
    "lastNames": "string",
    "status": "string"
  },
  "credential": {
    "number": "string",
    "issuedAt": "string",
    "expiresAt": "string"
  }
}
```

### Asistencia

#### Registrar Asistencia
```http
POST /attendance
```

Body:
```json
{
  "studentId": "string",
  "courseId": "string",
  "status": "present" | "absent" | "late",
  "date": "string",
  "notes": "string"
}
```

#### Obtener Asistencia
```http
GET /attendance
```

Query Parameters:
```
studentId: string
courseId: string
startDate: string
endDate: string
```

Response:
```json
{
  "data": [
    {
      "id": "string",
      "studentId": "string",
      "courseId": "string",
      "status": "string",
      "date": "string",
      "notes": "string"
    }
  ]
}
```

### Reportes

#### Generar Reporte
```http
POST /reports
```

Body:
```json
{
  "type": "attendance" | "grades" | "credentials",
  "format": "pdf" | "excel" | "csv",
  "filters": {
    "startDate": "string",
    "endDate": "string",
    "courseId": "string",
    "studentId": "string"
  }
}
```

Response:
```json
{
  "id": "string",
  "url": "string",
  "expiresAt": "string"
}
```

## Códigos de Estado

- 200: OK
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 500: Internal Server Error

## Límites de Rate

- 100 peticiones por minuto por IP
- 1000 peticiones por hora por usuario autenticado

## Errores

Formato de error estándar:
```json
{
  "error": {
    "code": "string",
    "message": "string",
    "details": {}
  }
}
```

### Códigos de Error Comunes

- `AUTH_001`: Credenciales inválidas
- `AUTH_002`: Token expirado
- `STUDENT_001`: Estudiante no encontrado
- `CREDENTIAL_001`: Credencial inválida
- `RATE_LIMIT_EXCEEDED`: Límite de peticiones excedido

## Versionado

La API usa versionado semántico en la URL. La versión actual es `v1`.

## Notas Adicionales

- Todas las fechas están en formato ISO 8601
- Los IDs son strings UUID v4
- Las respuestas están paginadas por defecto
- Usar gzip para compresión
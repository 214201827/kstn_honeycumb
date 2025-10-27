# Credenciales físicas — Honeycumb

Este documento define el diseño, especificaciones y flujo de impresión para las credenciales físicas (tarjetas de identificación) del sistema Honeycumb.

## Objetivo
Proveer especificaciones claras para generar, imprimir y distribuir credenciales físicas seguras y estandarizadas que contengan datos del estudiante y mecanismos de verificación (QR/Barcode).

## Requisitos funcionales clave
- Cada estudiante podrá recibir una credencial física única.
- La credencial contendrá foto, nombre completo, número de credencial, curso/grado, vigencia y un QR código que verifique la credencial en el sistema.
- Debe existir un historial de emisiones y reposiciones.
- Soportar impresión por lotes y reposiciones individuales.

## Campos en la tarjeta
- Logo de la institución (opcional, superior izquierda)
- Nombre de la institución
- Foto del estudiante (35x45 mm recomendada, alta resolución)
- Nombre completo del estudiante
- ID interno (UUID o numeración institucional)
- Número de credencial (formato: AA######## o YY#####)
- Curso / Grado / Sección
- Fecha de emisión
- Fecha de expiración
- Código QR (URL cifrada o token)
- Banda magnética / código de barras (opcional)
- Datos de contacto del centro (pequeño)
- Firma digital o sello (opcional)

## Especificaciones físicas y diseño
- Tamaño estándar recomendado: CR80 (85.60 × 53.98 mm)
- Grosor: 0.76 mm PVC (tarjeta tipo banco)
- Sangrado (bleed): 3 mm alrededor para recorte profesional
- Margen de seguridad interno: 4 mm
- Resolución de imágenes: 300 dpi mínimo para fotografía y logos
- Colores: CMYK para impresión; Proporcionar versión Pantone si aplica
- Tipografía: Sans-serif legible (p. ej. Inter, Roboto).
- Doble cara: frente con foto y datos, reverso con QR y condiciones / información adicional.

Nota sobre sublimación

Si se imprimirá mediante sublimación (dye-sublimation), ten en cuenta las siguientes observaciones:

- El proceso de sublimación requiere que el sustrato tenga un recubrimiento poliéster (o sea de color claro/blanco). La tinta de sublimación no contiene blanco: las áreas "blancas" deben ser reales del sustrato.
- Para impresión por sublimación se recomiendan tarjetas CR80 con recubrimiento para sublimación (polyester-coated PVC o tarjetas PET recubiertas). No todas las tarjetas PVC estándar son compatibles.
- Para doble cara mediante sublimación se presiona cada lado por separado y se requiere un control rígido de registro.


## Formato y codificación del QR
- El QR deberá apuntar a una URL de verificación, p. ej. `https://honeycumb.edu/verify/<credentialNumber>?v=<signature>`
- Para mayor seguridad, la parte `signature` será un HMAC (SHA256) sobre `credentialNumber|expiry` usando una clave de servidor.
- El endpoint de verificación no debe requerir autenticación para permitir escaneo por personal y dispositivos móviles, pero deberá aplicar medidas de rate-limiting y logging.
- También se puede implementar un token de un solo uso o firma corta con expiración corta para operaciones sensibles.

## Seguridad y anti-fraude
- Firma HMAC embebida en la URL del QR para evitar generación manual.
- Opción de banda magnética o código de barras con número interno (si se usan sistemas de control de accesos antiguos).
- Registro de reposición con motivo y usuario que la solicitó.
- Opción de impresión con elementos de seguridad: holograma, tinta UV, microtextos, laminado.

## Flujo de generación e impresión
1. Generación: El administrador solicita la generación de credenciales para un conjunto de estudiantes.
2. Render en servidor: Cada credencial se renderiza como PDF (una página por tarjeta) con marcas de corte y bleed.
3. Revisión: Vista previa en pantalla y validación de datos (foto, nombre, curso).
4. Firma HMAC: Generar firma para cada credentialNumber y guardarla en `studentCredentials`.
5. Impresión: Imprimir en una impresora de tarjetas (o servicio profesional) usando el PDF con marcas.
6. Laminado y acabado: Laminado si aplica, y empaquetado por lote.
7. Registro: Marcar credenciales como entregadas y registrar firma de receptor.

## Formato de datos en base de datos
Tabla: `studentCredentials`
- credentialId (pk)
- studentId (fk)
- credentialNumber (string, unique)
- issueDate (date)
- expiryDate (date)
- qrSignature (string)
- qrUrl (string)
- isActive (boolean)
- printedBy (userId)
- printedAt (datetime)
- replacedAt (datetime)

## Reposición y anulación
- Reposición: Generar nuevo número (o mantener número y registrar reposiciones) y marcar anterior como inválida.
- Anulación: isActive = false y registrar motivo, usuario y fecha.

## Recomendaciones de impresión
- Preferir servicio profesional para grandes volúmenes.
- Para pequeñas cantidades, impresora de tarjetas (Evolis, Zebra) con driver PCL/PSD.
- Verificar perfiles de color y pruebas de impresión antes del lote final.
- Guardar PDFs con sangrado y marcas de corte.

Sublimación (resumen rápido)
- Usa tinta de sublimación y papel transfer de calidad (TexPrint, Neenah).
- Prepara los assets en CMYK con perfil ICC del proveedor de tinta.
- Rasteriza imágenes a 300–600 dpi antes de exportar.
- Usa un jig y protección (Teflon) en la prensa para obtener registro consistente.

## Ejemplo rápido: HTML/SVG de plantilla (simplificada)

```html
<!-- Simple card SVG (aprox. CR80) -->
<svg width="856" height="539" viewBox="0 0 856 539" xmlns="http://www.w3.org/2000/svg">
  <rect width="100%" height="100%" rx="18" fill="#ffffff" stroke="#e2e8f0" />
  <image href="logo.png" x="24" y="24" width="120" height="40" />
  <rect x="24" y="80" width="200" height="260" fill="#f3f4f6" />
  <image href="photo.jpg" x="34" y="90" width="180" height="240" />
  <text x="250" y="120" font-size="28" font-family="Inter">Nombre Estudiante</text>
  <text x="250" y="160" font-size="20" fill="#6b7280">Curso / Grado</text>
  <text x="250" y="200" font-size="18">ID: 123e4567-e89b-12d3-a456-426614174000</text>
  <image href="qr.png" x="640" y="330" width="160" height="160" />
</svg>
```

> Nota: El SVG anterior es un ejemplo que puede escalarse y adaptarse para crear PDFs de impresión.

## Checklist rápido antes de imprimir
- [ ] Fotos a 300 dpi y correctamente recortadas
- [ ] Márgenes y sangrado configurados
- [ ] QR probado y verificado
- [ ] Datos personales revisados
- [ ] Copia de seguridad de PDFs de impresión

## Siguientes pasos propuestos
1. Implementar endpoint que genere el PDF de impresión para un lote.
2. Añadir pruebas automáticas que verifiquen la firma HMAC de cada QR.
3. Crear flujo en frontend para validación previa a la impresión (preview y confirmación).
4. Diseñar plantilla oficial con identidad visual de la institución.

---

Documento creado: Octubre 2025 — Honeycumb

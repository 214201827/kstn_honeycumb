# Guía rápida de impresión — Credenciales físicas (Honeycumb)

Este documento explica cómo convertir la plantilla SVG en PDFs listos para impresión, recomendaciones de color, sangrado, marcas de corte y pasos de verificación.

## Archivos relevantes
- `assets/credential-template.svg` — Plantilla base (reemplaza `photo.jpg`, `logo.png`, `qr.png` antes de exportar).
- `doc/CREDENTIALS_PHYSICAL.md` — Especificaciones detalladas (tamaño CR80, campos, seguridad).

## Requisitos para exportar
- Inkscape (recomendado) o Illustrator
- Ghostscript (para manipular PDF)
- Opcional: impresora de tarjetas (Evolis, Zebra)

## Recomendaciones de exportación
1. Trabaja con imágenes a 300 dpi como mínimo (especialmente la fotografía del estudiante y el logo).
2. Exporta en CMYK si tu impresora lo requiere (Inkscape por defecto trabaja en RGB; para conversión profesional usa Illustrator o un flujo de color adecuado).
3. Añade 3 mm de bleed (sangrado) alrededor y marcas de corte.
4. Mantén un margen de seguridad interno de 4 mm para evitar que texto o elementos importantes queden muy juntos al borde.

## Comandos útiles
### Exportar SVG a PDF con Inkscape (Linux)

```bash
# Instalar inkscape si no está disponible
# Debian/Ubuntu
sudo apt-get update && sudo apt-get install inkscape -y

# Exportar a PDF (una página por SVG)
inkscape assets/credential-template.svg --export-type=pdf --export-filename=out/credential-template.pdf
```

### Exportar con marcas de corte y bleed (usando Inkscape)
- Ajusta el documento en Inkscape añadiendo un rectángulo mayor (por bleed) y exporta la página completa.

### Convertir a PDF/A o manipular con Ghostscript

```bash
# Normalizar PDF
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer \
   -dNOPAUSE -dBATCH -sOutputFile=out/credential-template-final.pdf out/credential-template.pdf
```

## Impresión por lotes
1. Genera un PDF con una página por tarjeta (una entrada por estudiante). Puedes usar una plantilla y sustituir dinámicamente `photo.jpg` y `qr.png` por cada estudiante y exportar páginas independientes.
2. Combina las páginas en un único PDF (orden de impresión). Herramientas: `pdfunite` (poppler-utils) o `gs`.

```bash
# Unir varios PDFs en uno
pdfunite page1.pdf page2.pdf page3.pdf batch/credentials-batch.pdf
```

## Flujo recomendado para lotes (resumen)
1. Generar assets por estudiante: photo, qr
2. Copiar `credential-template.svg` a un workspace temporal y reemplazar los href de las imágenes por paths locales (photo.jpg, qr.png)
3. Exportar a PDF 1 página por archivo
4. Unir PDFs en orden deseado
5. Revisar en pantalla y en prueba de impresión (1-2 copias físicas)
6. Imprimir lote en impresora de tarjetas o enviar a imprenta profesional

## Verificación previa a impresión
- Abrir el PDF final y comprobar que:
  - Los QR se escanean correctamente y apuntan al endpoint de verificación
  - Nombres y IDs se corresponden con registros
  - Fotos no pixeladas
  - Margen y bleed respetados

## Impresoras recomendadas
- Evolis Primacy, Evolis Zenius (uso institucional)
- Zebra ZC300, Zebra ZXP Series (uso industrial)

## Sublimación (dye-sublimation)

Si vas a imprimir las credenciales mediante sublimación, sigue estas recomendaciones específicas. La sublimación transfiere tinta directamente a un recubrimiento de poliéster: no existe tinta blanca, por lo que la superficie debe ser blanca o tener un recubrimiento apto para sublimación.

Recomendaciones de hardware
- Impresoras recomendadas (sublimación): Sawgrass Virtuoso (SG500 / SG1000) para tiradas pequeñas/medianas; impresoras Epson EcoTank o L-series reconvertidas con tintas de sublimación (Hiipoo, Sublijet compatibles) para volúmenes mayores.
- Prensa de calor plana para sustratos rígidos o prensa de roller según el flujo del fabricante.
- Placas o jigs para mantener las tarjetas inmóviles durante la transferencia.

Sustratos compatibles
- Tarjetas CR80 con recubrimiento para sublimación (polyester-coated PVC / PET). Muchos fabricantes venden "sublimation PVC cards" o "polyester sublimation cards" en formato CR80.
- Aluminio o acero recubierto para sublimación si se requiere una placa metálica.

Materiales
- Tintas de sublimación (Sublijet HD, Sawgrass Sublimation Inks, o equivalentes certificados).
- Papel transfer de calidad (TexPrint R, Neenah, etc.).
- Papel de protección (Teflon sheet / silicon paper) para evitar manchas en la prensa.

Preprocesamiento y color
- Trabaja en CMYK y aplica el perfil ICC del fabricante de tintas para mejor correspondencia de color.
- Convierte todos los textos a curvas y rasteriza las imágenes manteniendo 300–600 dpi para el tamaño final.
- Recuerda que la sublimación no imprime blanco: cualquier zona que deba permanecer blanca debe ser la del recubrimiento del sustrato.

Parámetros de prensa (valores orientativos — siempre probar en tu equipo)
- Temperatura: 180–205 °C (356–401 °F). Para la mayoría de tarjetas recubiertas, 190–200 °C es un buen punto de partida.
- Tiempo: 45–90 segundos según sustrato y prensa.
- Presión: media-alta; suficiente para asegurar contacto uniforme entre el papel y la tarjeta.

Flujo de trabajo recomendado (sublimación)
1. Genera el artwork final con sangrado y marcas y rasteriza a 300–600 dpi.
2. Aplica perfil ICC y convierte a CMYK.
3. Imprime espejo (mirror) sobre papel transfer de sublimación con la impresora configurada y usando tinta de sublimación.
4. Recorta el transfer si es necesario y colócalo sobre la tarjeta (lado impreso en contacto con la superficie recubierta).
5. Coloca protección (papel o teflon) entre la prensa y el conjunto para evitar manchas.
6. Presiona con la temperatura/tiempo adecuado. Usar un jig o placa para tarjetas evita desplazamientos y quemaduras en la prensa.
7. Retira la tarjeta y deja enfriar según recomiende el proveedor; en muchos casos el despegue (paper peel) se hace en caliente o tibio según la combinación de materiales.
8. Inspecciona color, registro y calidad. Repite ajustes si es necesario.

Consejos y consideraciones
- Realiza pruebas de color y tiempo/temperatura con muestras antes de producir lotes.
- Para doble cara, imprime y presiona cada cara por separado, teniendo cuidado con el alineado y la protección de la primera cara.
- Registra los parámetros que funcionen para cada tipo de sustrato y lote.
- Evita superficies oscuras o metálicas sin recubrimiento blanco: la sublimación no producirá blanco.
- Para efectos especiales (hologramas, laminado), aplica el acabado tras la sublimación y la verificación de color.

Problemas comunes y soluciones
- Color pálido o desaturado: aumentar la temperatura o el tiempo, o verificar el perfil ICC/tintas.
- Registro desalineado: usar jigs y recortar el transfer con precisión; reducir velocidad de manejo.
- Manchas en la prensa: usar papel protector y mantener la prensa limpia.

¿Quieres que implemente un script automático que genere los PDFs y prepare los assets para sublimación (rasterización, aplicación de perfil ICC, mirror + export) y que invoque Inkscape o Puppeteer para batch? Indica el stack preferido y lo preparo.

## Perfil de color y pruebas
- Para lotes profesionales, genera pruebas en CMYK y prueba el color en la impresora final.
- Realiza una impresión de prueba por lote (5-10 tarjetas) para confirmar calidad y ajuste de color.

## Consejos de seguridad y control de calidad
- Genera el PDF en un entorno controlado (backend o servidor de generación) y almacena en un bucket con acceso restringido.
- Registra quién generó y descargó el PDF de impresión.
- Conserva un backup del PDF final por motivos de auditoría.

## Ejemplo de script (pseudocódigo) para generar lotes

1. Recibir lista de estudiantes (JSON)
2. Para cada estudiante:
   - Generar `qr.png` con la URL firmada
   - Descargar/recortar la `photo.jpg` a 300 dpi
   - Reemplazar referencias en la plantilla SVG por archivos locales
   - Llamar a Inkscape para exportar PDF de la tarjeta
3. Unir PDFs y mover a `out/` para revisión

---

Si quieres, implemento:
- Un pequeño script Node.js que reciba un CSV/JSON de estudiantes y genere el PDF final por lote (usa Puppeteer/Sharp o invoca Inkscape en CLI).
- Un endpoint en el backend para generar PDFs on-demand y devolver un enlace S3 seguro.

Indícame si prefieres que implemente el script Node.js o el endpoint del backend ahora y qué stack quieres usar (Express/Fastify + puppeteer/prince/inkscape).
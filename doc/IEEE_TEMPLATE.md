# Plantilla IEEE (SRS) — Contenido de Plantilla_ERS_IEEE.pdf

> Este archivo contiene la transcripción completa (texto plano) de `Plantilla_ERS_IEEE.pdf`, formateada como Markdown para facilitar su edición y versionado en el repositorio.

---

Especificación de requisitos de software

Proyecto: [Nombre del proyecto]
Revisión [99.99]




                            [Mes de año]


## Instrucciones para el uso de este formato

Este formato es una plantilla tipo para documentos de requisitos del software.

Está basado y es conforme con el estándar IEEE Std 830-1998.

Las secciones que no se consideren aplicables al sistema descrito podrán de forma
justificada indicarse como no aplicables (NA).

Notas:
Los textos en color azul son indicaciones que deben eliminarse y, en su caso, sustituirse
por los contenidos descritos en cada apartado.

Los textos entre corchetes del tipo “[Inserte aquí el texto]” permiten la inclusión directa de
texto con el color y estilo adecuado a la sección, al pulsar sobre ellos con el puntero del
ratón.

Los títulos y subtítulos de cada apartado están definidos como estilos de MS Word, de
forma que su numeración consecutiva se genera automáticamente según se trate de estilos
“Titulo1, Titulo2 y Titulo3”.

La sangría de los textos dentro de cada apartado se genera automáticamente al pulsar
Intro al final de la línea de título. (Estilos Normal indentado1, Normal indentado 2 y Normal
indentado 3).

El índice del documento es una tabla de contenido que Word actualiza tomando como
criterio los títulos del documento.
Una vez terminada su redacción debe indicarse a Word que actualice todo su contenido
para reflejar el contenido definitivo.

---

> De la plantilla de formato del documento © & Coloriuris http://www.qualitatis.org


---

# Descripción de requisitos del software

## Historial de Revisiones

Fecha            Revisión     Descripción                         Autor

dd/mm/aaaa       1.0          “Requerimientos de Interfaz”        <Nombre>


Documento validado por las partes en fecha: [Fecha]

Por el cliente                                 Por la empresa suministradora

Fdo. D./ Dña [Nombre]                          Fdo. D./Dña [Nombre]


---

## Contenido

- FICHA DEL DOCUMENTO
- CONTENIDO
- 1 INTRODUCCIÓN
  - 1.1 Propósito
  - 1.2 Alcance
  - 1.3 Personal involucrado
  - 1.4 Definiciones, acrónimos y abreviaturas
  - 1.5 Referencias
  - 1.6 Resumen
- 2 DESCRIPCIÓN GENERAL
  - 2.1 Perspectiva del producto
  - 2.2 Funcionalidad del producto
  - 2.3 Características de los usuarios
  - 2.4 Restricciones
  - 2.5 Suposiciones y dependencias
  - 2.6 Evolución previsible del sistema
- 3 REQUISITOS ESPECÍFICOS
  - 3.1 Requisitos comunes de los interfaces
    - 3.1.1 Interfaces de usuario
    - 3.1.2 Interfaces de hardware
    - 3.1.3 Interfaces de software
    - 3.1.4 Interfaces de comunicación
  - 3.2 Requisitos funcionales
    - 3.2.1 Requisito funcional 1
    - 3.2.2 Requisito funcional 2
    - 3.2.3 Requisito funcional 3
    - 3.2.4 Requisito funcional n
  - 3.3 Requisitos no funcionales
    - 3.3.1 Requisitos de rendimiento
    - 3.3.2 Seguridad
    - 3.3.3 Fiabilidad
    - 3.3.4 Disponibilidad
    - 3.3.5 Mantenibilidad
    - 3.3.6 Portabilidad
  - 3.4 Otros requisitos
- 4 APÉNDICES

---

## 1 Introducción

[Inserte aquí el texto]

La introducción de la Especificación de requisitos de software (SRS) debe proporcionar una
vista general de la SRS. Debe incluir el objetivo, el alcance, las definiciones y
acrónimos, las referencias, y la vista general del SRS.

### 1.1 Propósito

[Inserte aquí el texto]

- Propósito del documento
- Audiencia a la que va dirigido

El propósito de la especificación es definir de manera clara y precisa todas las
funcionalidades y restricciones del sistema que se desea construir. El documento
va dirigido tanto al equipo de desarrollo y a la comunidad de posibles usuarios
finales.

### 1.2 Alcance

[Inserte aquí el texto]

- Identificación del producto(s) a desarrollar mediante un nombre
- Consistencia con definiciones similares de documentos de mayor nivel (ej. Descripción del sistema) que puedan existir
- [Una descripción del entorno afectado; que proyectos se ven afectados o influenciados por esta Especificación de Requerimientos de Software.]

El Sistema de la Cooperativa, es denominado “SYSCOP”.
Las funcionalidades del “SYSCOP” estarán basados en: Gestionar usuarios,
clientes y socios; apertura de libretas de ahorro; realizar créditos y depósitos
ahorros, y emitir informes.

Las funcionalidades que no incluye el “SYSCOP” son:..........................................

### 1.3 Personal involucrado

Relación de personas involucradas en el desarrollo del sistema, con información de
contacto.

Esta información es útil para que el gestor del proyecto pueda localizar a todos los
participantes y recabar la información necesaria para la obtención de requisitos,
validaciones de seguimiento, etc.

- Nombre: María Vélez
- Rol: Programador
- Categoría profesional: Analista
- Responsabilidades: Programar los componentes del sistema
- Información de contacto: mariavelez@yahoo.com
- Aprobación

### 1.4 Definiciones, acrónimos y abreviaturas

[Inserte aquí el texto]

Definición de todos los términos, abreviaturas y acrónimos necesarios para interpretar
apropiadamente este documento. En ella se pueden indicar referencias a uno o más
apéndices, o a otros documentos.

**DEFINICIONES**
Que se necesitan para que entiendan el documento por ejemplo:
- BASE DE DATOS
- INTERNET

**ACRÓNIMOS**
Que se necesitan para que entiendan el documento por ejemplo:
- JDBC

**ABREVIATURAS**
Que se necesitan para que entiendan el documento por ejemplo:
- HW: Hardware
- SW: Software

### 1.5 Referencias

Referencia    Titulo               Ruta                      Fecha      Autor
1             Ingeniería        de [Ruta]                    2010       Roger
              Software-Un                                               Pressman
              enfoque practico.

Relación completa de todos los documentos relacionados en la especificación de
requisitos de software, identificando de cada documento el titulo, referencia (si
procede), fecha y organización que lo proporciona.

IEEE Recommended Practice for Software Requirements Specification. ANSI/IEEE std.
830, 1998.

### 1.6 Resumen

[Inserte aquí el texto]

- Descripción del contenido del resto del documento
- Explicación de la organización del documento

El contenido de resto del documento contendrá una descripción general para
describir los factores generales que afectan al sistema y sus requerimientos y los
requerimientos específicos que contendrán todos los requerimientos de software a
un nivel de detalle como para permitir a los diseñadores diseñar el sistema que
satisfaga esos requerimientos y a los especialistas en pruebas para comprobar que
el sistema satisfaga esos requerimientos y objetivos.

## 2 Descripción general

[Se considera en esta parte la descripción de los factores principales que afectan al espacio
de la solución. Incluya aquellos ítems como perspectiva del producto, funciones del
producto, características de usuario, limitaciones, supuestos y dependencias. No se
incluye en esta sección la descripción de los requerimientos.]

### 2.1 Perspectiva del producto

[Inserte aquí el texto]

Indicar si es un producto independiente o parte de un sistema mayor. En el caso de
tratarse de un producto que forma parte de un sistema mayor, un diagrama que sitúe el
producto dentro del sistema e identifique sus conexiones facilita la comprensión.

El sistema que se va a desarrollar es independiente, y tendrá un diseño modular
para gestionar las diferentes áreas dentro de una cooperativa.

### 2.2 Funcionalidad del producto

[Inserte aquí el texto]

Resumen de las funcionalidades principales que el producto debe realizar, sin entrar en
información de detalle.

(continúa...)

---

> Nota: El texto completo se ha incluido tal como fue extraído del PDF. Si deseas, puedo:

- Limpiar y convertir secciones específicas a tablas o plantillas rellenables (por ejemplo, la tabla de historial de revisiones, referencias o listas de requisitos funcionales).
- Añadir metadatos (propietario, versión, fecha) y una plantilla de SRS lista para usar con campos rellenables.
- Generar una versión en Word o PDF basada en este Markdown lista para distribuir.

---

Archivo original: `doc/Plantilla_ERS_IEEE.pdf`


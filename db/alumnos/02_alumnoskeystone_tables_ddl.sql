-- ============================================================
--  ALUMNOS_KEYSTONE - Esquema con grupos basados en ENUM
--  y validación por triggers de combinaciones nivel/grado
-- ============================================================

-- (Opcional) endurecer validaciones
SET sql_mode = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- ------------------------------------------------------------
-- Esquema base
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS ALUMNOS_KEYSTONE
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE ALUMNOS_KEYSTONE;

-- ------------------------------------------------------------
-- Tabla: contacto_principal
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS contacto_principal (
  contacto_principal_id INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(100) NOT NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  telefono      VARCHAR(20),
  direccion     TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabla: aulas (piso + número)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS aulas (
  aula_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  piso     CHAR(3) NOT NULL,
  numero   CHAR(3) NOT NULL,
  UNIQUE(piso,numero)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==================================================================
-- Tabla: grupos (NUEVA DEFINICIÓN con ENUM y TRIGGERS de validación)
-- ==================================================================
-- Cambios clave vs. DDL previo:
--  - Se elimina dependencia de tablas grados/secciones.
--  - Se representan directamente: nivel, grado, seccion como ENUM.
--  - Se agrega UNIQUE(nivel, grado, seccion).
--  - Triggers BEFORE INSERT/UPDATE validan combinaciones válidas.
-- ==================================================================
CREATE TABLE IF NOT EXISTS grupos (
  grupo_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nivel      ENUM('Kinder','Primaria','Secundaria') NOT NULL,
  grado      ENUM('1','2','3','4','5','6') NOT NULL,
  seccion    ENUM('A','B','C','D','E','F') NOT NULL,
  aula_id    INT UNSIGNED NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT uk_grupos_nivel_grado_seccion UNIQUE (nivel, grado, seccion),

  CONSTRAINT fk_grupos_aula
    FOREIGN KEY (aula_id) REFERENCES aulas(aula_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- TRIGGERS de validación en grupos
-- ------------------------------------------------------------
DELIMITER $$

CREATE TRIGGER grupos_bi_nivel_grado_chk
BEFORE INSERT ON grupos
FOR EACH ROW
BEGIN
  -- Kinder: grados 1..3
  IF NEW.nivel='Kinder' AND NEW.grado NOT IN ('1','2','3') THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Kinder sólo admite grados 1 a 3';
  END IF;

  -- Primaria: grados 1..6
  IF NEW.nivel='Primaria' AND NEW.grado NOT IN ('1','2','3','4','5','6') THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Primaria sólo admite grados 1 a 6';
  END IF;

  -- Secundaria: grados 1..3
  IF NEW.nivel='Secundaria' AND NEW.grado NOT IN ('1','2','3') THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Secundaria sólo admite grados 1 a 3';
  END IF;
END$$

CREATE TRIGGER grupos_bu_nivel_grado_chk
BEFORE UPDATE ON grupos
FOR EACH ROW
BEGIN
  -- Kinder: grados 1..3
  IF NEW.nivel='Kinder' AND NEW.grado NOT IN ('1','2','3') THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Kinder sólo admite grados 1 a 3';
  END IF;

  -- Primaria: grados 1..6
  IF NEW.nivel='Primaria' AND NEW.grado NOT IN ('1','2','3','4','5','6') THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Primaria sólo admite grados 1 a 6';
  END IF;

  -- Secundaria: grados 1..3
  IF NEW.nivel='Secundaria' AND NEW.grado NOT IN ('1','2','3') THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Secundaria sólo admite grados 1 a 3';
  END IF;
END$$

DELIMITER ;

-- ------------------------------------------------------------
-- Tabla: alumnos
--  - Sin cambios en FK: sigue apuntando a grupos(grupo_id).
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS alumnos (
  alumno_id             INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre                VARCHAR(100) NOT NULL,
  apellido_paterno      VARCHAR(100) NOT NULL,
  apellido_materno      VARCHAR(100),
  matricula             VARCHAR(15) UNIQUE,
  curp                  CHAR(18) UNIQUE NOT NULL,
  fecha_nacimiento      DATE,
  tipo_sangre           ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-'),
  grupo                 INTEGER UNSIGNED,
  correo_institucional  VARCHAR(255),
  contacto_principal    INTEGER UNSIGNED,
  created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  activo                BOOLEAN DEFAULT TRUE NOT NULL,
  tieneMonitor          BOOLEAN DEFAULT FALSE NOT NULL,

  CONSTRAINT fk_alumno_grupo
    FOREIGN KEY (grupo) REFERENCES grupos(grupo_id)
    ON DELETE SET NULL ON UPDATE CASCADE,

  CONSTRAINT fk_alumno_contacto
    FOREIGN KEY (contacto_principal) REFERENCES contacto_principal(contacto_principal_id)
    ON DELETE SET NULL ON UPDATE CASCADE,

  CONSTRAINT chk_curp
    CHECK (curp REGEXP '^[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}$'),

  CONSTRAINT chk_correo
    CHECK (correo_institucional LIKE '%_@__%.__%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabla: retardos
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS retardos (
  id_retardo    INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  alumno        INTEGER UNSIGNED,
  persona_firma INTEGER UNSIGNED,
  hora_llegada  DATETIME,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (alumno) REFERENCES alumnos(alumno_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabla: lideres_familia
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS lideres_familia (
  lider_id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(100) NOT NULL,
  apellidos       VARCHAR(70) NOT NULL,
  telefonos_lider INTEGER UNSIGNED,
  emails_lider    INTEGER UNSIGNED,
  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  direccion       TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabla: telefonos_lideres
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS telefonos_lideres (
  id_telefono   INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  lider_familia INTEGER UNSIGNED,
  telefono      VARCHAR(20) NOT NULL UNIQUE,
  tipo_telefono ENUM('Fijo','Celular','Trabajo','Otros'),
  principal     BOOLEAN,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_tel_lider
    FOREIGN KEY (lider_familia) REFERENCES lideres_familia(lider_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabla: emails_lideres
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS emails_lideres (
  id_email     INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  lider_familia INTEGER UNSIGNED,
  email         VARCHAR(100) UNIQUE,
  tipo_email    ENUM('Personal','Trabajo','Facturación','Otros'),
  principal     BOOLEAN,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_email_lider
    FOREIGN KEY (lider_familia) REFERENCES lideres_familia(lider_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_email_fmt CHECK (email LIKE '%_@__%.__%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabla: personas_autorizadas
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS personas_autorizadas (
  persona_id  INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(100) NOT NULL,
  telefono    VARCHAR(20),
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  direccion   TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Catálogos de salud
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS diagnosticos (
  diagnostico_id INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre         VARCHAR(100) NOT NULL,
  created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  descripcion    TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS padecimientos (
  padecimiento_id INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(100) NOT NULL,
  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  descripcion     TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS alergias (
  alergia_id  INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(100) NOT NULL,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  descripcion TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tablas relacionales (alumno_* con ON DELETE CASCADE)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS alumno_diagnostico (
  alumno_diagnostico_id INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  alumno_id      INTEGER UNSIGNED,
  diagnostico_id INTEGER UNSIGNED,
  notas          TEXT,
  created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (alumno_id) REFERENCES alumnos(alumno_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (diagnostico_id) REFERENCES diagnosticos(diagnostico_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS alumno_padecimiento (
  alumno_padecimiento_id INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  alumno_id       INTEGER UNSIGNED,
  padecimiento_id INTEGER UNSIGNED,
  notas           TEXT,
  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (alumno_id) REFERENCES alumnos(alumno_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (padecimiento_id) REFERENCES padecimientos(padecimiento_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS alumno_alergia (
  alumno_alergia_id INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  alumno_id  INTEGER UNSIGNED,
  alergia_id INTEGER UNSIGNED,
  notas      TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (alumno_id) REFERENCES alumnos(alumno_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (alergia_id) REFERENCES alergias(alergia_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS alumno_lider (
  alumno_lider_id INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  alumno_id  INTEGER UNSIGNED,
  lider_id   INTEGER UNSIGNED,
  parentezco VARCHAR(30),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (alumno_id) REFERENCES alumnos(alumno_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (lider_id) REFERENCES lideres_familia(lider_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS alumno_persona_autorizada (
  alumno_persona_autorizada_id INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  alumno_id INTEGER UNSIGNED,
  persona_id INTEGER UNSIGNED,
  parentezco VARCHAR(30),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (alumno_id) REFERENCES alumnos(alumno_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (persona_id) REFERENCES personas_autorizadas(persona_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================

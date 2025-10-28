-- ============================================================
-- 03_alumnoskeystone_audit_core.sql
--  Bitácora única de auditoría (tabla audit_log + índices)
-- ============================================================

CREATE DATABASE IF NOT EXISTS ALUMNOS_KEYSTONE
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE ALUMNOS_KEYSTONE;

CREATE TABLE IF NOT EXISTS audit_log (
  audit_id   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  table_name VARCHAR(64) NOT NULL,
  action     ENUM('I','U','D') NOT NULL,
  pk_json    JSON NOT NULL,
  old_row    JSON NULL,
  new_row    JSON NULL,
  changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  changed_by VARCHAR(255) NOT NULL DEFAULT CURRENT_USER(),
  tx_id      BIGINT UNSIGNED NOT NULL DEFAULT CONNECTION_ID(),
  CHECK (JSON_VALID(pk_json)),
  CHECK (old_row IS NULL OR JSON_VALID(old_row)),
  CHECK (new_row IS NULL OR JSON_VALID(new_row))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX IF NOT EXISTS ix_audit_tbl_act_time ON audit_log(table_name, action, changed_at);
CREATE INDEX IF NOT EXISTS ix_audit_time ON audit_log(changed_at);
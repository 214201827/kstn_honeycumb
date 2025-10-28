-- ============================================================
-- 05_alumnoskeystone_audit_generators.sql
--  Generadores de triggers (SPs) para la bitácora única
-- ============================================================

USE ALUMNOS_KEYSTONE;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_rebuild_audit_triggers $$
CREATE PROCEDURE sp_rebuild_audit_triggers(IN p_schema VARCHAR(64), IN p_table VARCHAR(64))
BEGIN
  DECLARE v_full VARCHAR(256);
  DECLARE v_tbl VARCHAR(128);
  DECLARE v_schema VARCHAR(128);
  DECLARE v_pk_pairs TEXT;
  DECLARE v_old_pairs LONGTEXT;
  DECLARE v_new_pairs LONGTEXT;
  DECLARE v_has_pk INT DEFAULT 0;

  SET v_schema = p_schema;
  SET v_tbl    = p_table;
  SET v_full   = CONCAT('`', v_schema, '`.`', v_tbl, '`');

  SELECT GROUP_CONCAT(CONCAT("'", COLUMN_NAME, "'", ', NEW.`', COLUMN_NAME, '`') ORDER BY ORDINAL_POSITION SEPARATOR ', ')
    INTO v_new_pairs
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = v_schema AND TABLE_NAME = v_tbl;

  SELECT GROUP_CONCAT(CONCAT("'", COLUMN_NAME, "'", ', OLD.`', COLUMN_NAME, '`') ORDER BY ORDINAL_POSITION SEPARATOR ', ')
    INTO v_old_pairs
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = v_schema AND TABLE_NAME = v_tbl;

  SELECT COUNT(*)
    INTO v_has_pk
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
  JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
   AND tc.TABLE_SCHEMA = kcu.TABLE_SCHEMA
   AND tc.TABLE_NAME   = kcu.TABLE_NAME
  WHERE tc.TABLE_SCHEMA = v_schema
    AND tc.TABLE_NAME   = v_tbl
    AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY';

  IF v_has_pk > 0 THEN
    SELECT GROUP_CONCAT(CONCAT("'", kcu.COLUMN_NAME, "'", ', NEW.`', kcu.COLUMN_NAME, '`') ORDER BY kcu.ORDINAL_POSITION SEPARATOR ', ')
      INTO v_pk_pairs
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
    JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
      ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
     AND tc.TABLE_SCHEMA = kcu.TABLE_SCHEMA
     AND tc.TABLE_NAME   = kcu.TABLE_NAME
    WHERE tc.TABLE_SCHEMA = v_schema
      AND tc.TABLE_NAME   = v_tbl
      AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY';
  ELSE
    SET v_pk_pairs = v_new_pairs;
  END IF;

  SET @tr_ai = CONCAT('`tr_aud_', v_tbl, '_ai`');
  SET @tr_au = CONCAT('`tr_aud_', v_tbl, '_au`');
  SET @tr_ad = CONCAT('`tr_aud_', v_tbl, '_ad`');

  SET @sql = CONCAT('DROP TRIGGER IF EXISTS ', @tr_ai); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  SET @sql = CONCAT('DROP TRIGGER IF EXISTS ', @tr_au); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  SET @sql = CONCAT('DROP TRIGGER IF EXISTS ', @tr_ad); PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

  SET @sql = CONCAT(
    'CREATE TRIGGER ', @tr_ai, ' AFTER INSERT ON ', v_full, ' ',
    'FOR EACH ROW BEGIN ',
      'INSERT INTO `', v_schema, '`.`audit_log`(table_name, action, pk_json, old_row, new_row, changed_by) VALUES (',
        "'", v_tbl, "'", ', ''I'', ',
        'JSON_OBJECT(', v_pk_pairs, '), ',
        'NULL, ',
        'JSON_OBJECT(', v_new_pairs, '), ',
        'COALESCE(@audit_actor, CURRENT_USER())',
      '); ',
    'END'
  );
  PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

  SET @sql = CONCAT(
    'CREATE TRIGGER ', @tr_au, ' AFTER UPDATE ON ', v_full, ' ',
    'FOR EACH ROW BEGIN ',
      'INSERT INTO `', v_schema, '`.`audit_log`(table_name, action, pk_json, old_row, new_row, changed_by) VALUES (',
        "'", v_tbl, "'", ', ''U'', ',
        'JSON_OBJECT(', v_pk_pairs, '), ',
        'JSON_OBJECT(', v_old_pairs, '), ',
        'JSON_OBJECT(', v_new_pairs, '), ',
        'COALESCE(@audit_actor, CURRENT_USER())',
      '); ',
    'END'
  );
  PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

  IF v_has_pk > 0 THEN
    SELECT GROUP_CONCAT(CONCAT("'", kcu.COLUMN_NAME, "'", ', OLD.`', kcu.COLUMN_NAME, '`') ORDER BY kcu.ORDINAL_POSITION SEPARATOR ', ')
      INTO @pk_old_pairs
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
    JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
      ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
     AND tc.TABLE_SCHEMA = kcu.TABLE_SCHEMA
     AND tc.TABLE_NAME   = kcu.TABLE_NAME
    WHERE tc.TABLE_SCHEMA = v_schema
      AND tc.TABLE_NAME   = v_tbl
      AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY';
  ELSE
    SET @pk_old_pairs = v_old_pairs;
  END IF;

  SET @sql = CONCAT(
    'CREATE TRIGGER ', @tr_ad, ' AFTER DELETE ON ', v_full, ' ',
    'FOR EACH ROW BEGIN ',
      'INSERT INTO `', v_schema, '`.`audit_log`(table_name, action, pk_json, old_row, new_row, changed_by) VALUES (',
        "'", v_tbl, "'", ', ''D'', ',
        'JSON_OBJECT(', @pk_old_pairs, '), ',
        'JSON_OBJECT(', v_old_pairs, '), ',
        'NULL, ',
        'COALESCE(@audit_actor, CURRENT_USER())',
      '); ',
    'END'
  );
  PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
END $$

DROP PROCEDURE IF EXISTS sp_rebuild_all_audit_triggers $$
CREATE PROCEDURE sp_rebuild_all_audit_triggers(IN p_schema VARCHAR(64))
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE v_table VARCHAR(64);

  DECLARE cur CURSOR FOR
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = p_schema
      AND TABLE_TYPE = 'BASE TABLE'
      AND TABLE_NAME <> 'audit_log';

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  read_loop: LOOP
    FETCH cur INTO v_table;
    IF done = 1 THEN LEAVE read_loop; END IF;
    CALL sp_rebuild_audit_triggers(p_schema, v_table);
  END LOOP;
  CLOSE cur;
END $$

DELIMITER ;

-- Uso:
-- CALL sp_rebuild_all_audit_triggers('ALUMNOS_KEYSTONE');
-- CALL sp_rebuild_audit_triggers('ALUMNOS_KEYSTONE', 'alumnos');
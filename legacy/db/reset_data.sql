-- Script que da reset a la BD, es decir borra todos los datos pero deja el DDL intacto.

USE honeycumb;

DELETE FROM honeycumb.courses;
ALTER TABLE honeycumb.courses AUTO_INCREMENT = 1;

DELETE FROM honeycumb.registroAuditoria;
ALTER TABLE honeycumb.registroAuditoria AUTO_INCREMENT = 1;

DELETE FROM honeycumb.sessions;
ALTER TABLE honeycumb.sessions AUTO_INCREMENT = 1;

DELETE FROM honeycumb.studentCourses;
ALTER TABLE honeycumb.studentCourses AUTO_INCREMENT = 1;

DELETE FROM honeycumb.students;
ALTER TABLE honeycumb.students AUTO_INCREMENT = 1;

DELETE FROM honeycumb.userCourses;
ALTER TABLE honeycumb.userCourses AUTO_INCREMENT = 1;

DELETE FROM honeycumb.usuarios;
ALTER TABLE honeycumb.usuarios AUTO_INCREMENT = 1;


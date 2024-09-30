CREATE DATABASE honeycumb;

USE honeycumb;


-- honeycumb.courses definition

CREATE TABLE `courses` (
  `idCourse` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `courseName` varchar(100) NOT NULL,
  `googleClassroomData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`googleClassroomData`)),
  PRIMARY KEY (`idCourse`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- honeycumb.registroAuditoria definition

CREATE TABLE `registroAuditoria` (
  `auditoriaId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipoMovimiento` enum('DELETE','UPDATE') NOT NULL,
  `nombreUsuario` varchar(100) NOT NULL,
  `usuarioMovimiento` varchar(100) NOT NULL DEFAULT 'Desconocido',
  `usuarioQueRealizoAccion` varchar(100) NOT NULL DEFAULT 'Desconocido',
  `fechaMovimiento` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`auditoriaId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- honeycumb.students definition

CREATE TABLE `students` (
  `studentId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `names` varchar(50) NOT NULL,
  `lastNames` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `courses` int(10) unsigned DEFAULT NULL,
  `googleUserId` varchar(20) DEFAULT NULL,
  `googleClassroomData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`googleClassroomData`)),
  PRIMARY KEY (`studentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- honeycumb.studentCourses definition

CREATE TABLE `studentCourses` (
  `studentCourseId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `studentId` int(10) unsigned NOT NULL,
  `courseId` int(10) unsigned NOT NULL,
  `googleClassroomData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`googleClassroomData`)),
  PRIMARY KEY (`studentCourseId`),
  KEY `studentCourses_courses_FK` (`courseId`),
  KEY `studentCourses_students_FK` (`studentId`),
  CONSTRAINT `studentCourses_courses_FK` FOREIGN KEY (`courseId`) REFERENCES `courses` (`idCourse`) ON DELETE CASCADE,
  CONSTRAINT `studentCourses_students_FK` FOREIGN KEY (`studentId`) REFERENCES `students` (`studentId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- honeycumb.usuarios definition

CREATE TABLE `usuarios` (
  `userId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `names` varchar(30) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password_hash` text NOT NULL,
  `googleUserId` char(20) DEFAULT NULL,
  `users` int(10) unsigned DEFAULT NULL,
  `courseId` int(10) unsigned DEFAULT NULL,
  `sessions` int(10) unsigned DEFAULT NULL,
  `userType` enum('Administrador','Coordinador','Profesor') NOT NULL,
  `coordinador` int(10) unsigned DEFAULT NULL,
  `lastName` varchar(50) NOT NULL,
  PRIMARY KEY (`userId`),
  KEY `usuarios_usuarios_FK` (`users`),
  KEY `usuarios_sessions_FK` (`sessions`),
  KEY `usuarios_coordinador_FK` (`coordinador`),
  CONSTRAINT `usuarios_coordinador_FK` FOREIGN KEY (`coordinador`) REFERENCES `usuarios` (`userId`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- honeycumb.sessions definition

CREATE TABLE `sessions` (
  `sessionId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dateStart` datetime DEFAULT NULL,
  `dateExpiration` datetime DEFAULT NULL,
  `token` varchar(256) DEFAULT NULL,
  `userIpAddress` char(16) DEFAULT NULL,
  `userAgent` text DEFAULT NULL,
  `usuario` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`sessionId`),
  KEY `sessions_usuarios_FK` (`usuario`),
  CONSTRAINT `sessions_usuarios_FK` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`userId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- honeycumb.userCourses definition

CREATE TABLE `userCourses` (
  `userCoursesId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `course` int(10) unsigned NOT NULL,
  `user` int(10) unsigned NOT NULL,
  PRIMARY KEY (`userCoursesId`),
  KEY `userCourses_courses_FK` (`course`),
  KEY `userCourses_usuarios_FK` (`user`),
  CONSTRAINT `userCourses_courses_FK` FOREIGN KEY (`course`) REFERENCES `courses` (`idCourse`) ON DELETE CASCADE,
  CONSTRAINT `userCourses_usuarios_FK` FOREIGN KEY (`user`) REFERENCES `usuarios` (`userId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Cortar aquí si no funciona.

CREATE DEFINER=`david`@`localhost` FUNCTION `honeycumb`.`obtenerUserIdPorEmail`(correo VARCHAR(50)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE userId INT;

    -- Verificar si el usuario existe
    SELECT u.userId INTO userId
    FROM usuarios u
    WHERE u.email = correo
    LIMIT 1;

    -- Si no se encuentra un usuario, devolver NULL o un valor específico
    IF userId IS NULL THEN
        RETURN -1; -- Retornar -1 si el usuario no existe
    ELSE
        RETURN userId; -- Retornar el userId si se encontró
    END IF;
END;


-- Triggers

CREATE DEFINER=`david`@`localhost` TRIGGER `after_usuario_update`
AFTER UPDATE ON `usuarios`
FOR EACH ROW
BEGIN
    INSERT INTO `registroAuditoria` 
    (`tipoMovimiento`, `nombreUsuario`, `fechaMovimiento`, `usuarioQueRealizoAccion`)
    VALUES ('UPDATE', NEW.names, NOW(), CURRENT_USER());
END;

CREATE DEFINER=`david`@`localhost` TRIGGER `after_usuario_delete`
AFTER DELETE ON `usuarios`
FOR EACH ROW
BEGIN
    INSERT INTO `registroAuditoria` 
    (`tipoMovimiento`, `nombreUsuario`, `fechaMovimiento`, `usuarioQueRealizoAccion`)
    VALUES ('DELETE', OLD.names, NOW(), CURRENT_USER());
END;
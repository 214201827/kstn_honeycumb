-- MariaDB dump 10.19  Distrib 10.11.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: db    Database: honeycumb
-- ------------------------------------------------------
-- Server version	10.11.6-MariaDB-1:10.11.6+maria~ubu2204

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses` (
  `idCourse` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `courseName` varchar(100) NOT NULL,
  `googleClassroomData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`googleClassroomData`)),
  PRIMARY KEY (`idCourse`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES
(1,'Mathematics 101','{\"classroomId\": \"abc123\", \"teacher\": \"Mr. Smith\"}'),
(2,'Physics 101','{\"classroomId\": \"def456\", \"teacher\": \"Dr. Brown\"}'),
(3,'Chemistry 101','{\"classroomId\": \"ghi789\", \"teacher\": \"Ms. Johnson\"}'),
(4,'Biology 101','{\"classroomId\": \"jkl012\", \"teacher\": \"Mr. Doe\"}'),
(5,'History 101','{\"classroomId\": \"mno345\", \"teacher\": \"Mr. Adams\"}'),
(6,'Literature 101','{\"classroomId\": \"pqr678\", \"teacher\": \"Ms. King\"}'),
(7,'Computer Science 101','{\"classroomId\": \"stu901\", \"teacher\": \"Ms. Hall\"}');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registroAuditoria`
--

DROP TABLE IF EXISTS `registroAuditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `registroAuditoria` (
  `auditoriaId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipoMovimiento` enum('DELETE','UPDATE') NOT NULL,
  `nombreUsuario` varchar(100) NOT NULL,
  `usuarioMovimiento` varchar(100) NOT NULL DEFAULT 'Desconocido',
  `usuarioQueRealizoAccion` varchar(100) NOT NULL DEFAULT 'Desconocido',
  `fechaMovimiento` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`auditoriaId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registroAuditoria`
--

LOCK TABLES `registroAuditoria` WRITE;
/*!40000 ALTER TABLE `registroAuditoria` DISABLE KEYS */;
INSERT INTO `registroAuditoria` VALUES
(1,'UPDATE','Admin User','admin@example.com','admin@example.com','2024-10-31 21:39:26'),
(2,'UPDATE','Coord User','coord@example.com','admin@example.com','2024-10-31 21:39:26'),
(3,'DELETE','Prof Smith','smith@example.com','coord@example.com','2024-10-31 21:39:26'),
(4,'DELETE','Prof Brown','brown@example.com','coord@example.com','2024-10-31 21:39:26'),
(5,'UPDATE','Prof King','king@example.com','admin@example.com','2024-10-31 21:39:26');
/*!40000 ALTER TABLE `registroAuditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES
(1,'2024-10-31 21:39:26','2024-10-31 22:39:26','token1','192.168.0.1','Mozilla/5.0',1),
(2,'2024-10-31 21:39:26','2024-10-31 23:39:26','token2','192.168.0.2','Mozilla/5.0',2),
(3,'2024-10-31 21:39:26','2024-11-01 00:39:26','token3','192.168.0.3','Mozilla/5.0',3),
(4,'2024-10-31 21:39:26','2024-10-31 22:39:26','token4','192.168.0.4','Mozilla/5.0',4),
(5,'2024-10-31 21:39:26','2024-10-31 23:39:26','token5','192.168.0.5','Mozilla/5.0',5),
(6,'2024-10-31 21:39:26','2024-11-01 00:39:26','token6','192.168.0.6','Mozilla/5.0',6);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `studentCourses`
--

DROP TABLE IF EXISTS `studentCourses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `studentCourses`
--

LOCK TABLES `studentCourses` WRITE;
/*!40000 ALTER TABLE `studentCourses` DISABLE KEYS */;
INSERT INTO `studentCourses` VALUES
(1,1,1,'{\"classroomId\": \"abc123\", \"grade\": 95}'),
(2,1,2,'{\"classroomId\": \"def456\", \"grade\": 89}'),
(3,2,3,'{\"classroomId\": \"ghi789\", \"grade\": 76}'),
(4,2,4,'{\"classroomId\": \"jkl012\", \"grade\": 88}'),
(5,3,1,'{\"classroomId\": \"abc123\", \"grade\": 85}'),
(6,3,5,'{\"classroomId\": \"mno345\", \"grade\": 92}'),
(7,4,6,'{\"classroomId\": \"pqr678\", \"grade\": 80}'),
(8,5,7,'{\"classroomId\": \"stu901\", \"grade\": 85}');
/*!40000 ALTER TABLE `studentCourses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `students` (
  `studentId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `names` varchar(50) NOT NULL,
  `lastNames` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `googleUserId` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`studentId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES
(1,'John','Doe','john.doe@example.com','g123456'),
(2,'Jane','Doe','jane.doe@example.com','g6dock54321'),
(3,'Mike','Ross','mike.ross@example.com','g789123'),
(4,'Rachel','Zane','rachel.zane@example.com','g321987'),
(5,'Louis','Litt','louis.litt@example.com','g987654'),
(6,'Harvey','Specter','harvey.specter@example.com','g852369'),
(7,'Donna','Paulsen','donna.paulsen@example.com','g456789');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userCourses`
--

DROP TABLE IF EXISTS `userCourses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userCourses` (
  `userCoursesId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `course` int(10) unsigned NOT NULL,
  `user` int(10) unsigned NOT NULL,
  `comment` text DEFAULT NULL,
  `commentStatus` enum('No comentado','Pre-aprobado','Aprobado','No aprobado') NOT NULL DEFAULT 'No comentado',
  PRIMARY KEY (`userCoursesId`),
  KEY `userCourses_courses_FK` (`course`),
  KEY `userCourses_usuarios_FK` (`user`),
  CONSTRAINT `userCourses_courses_FK` FOREIGN KEY (`course`) REFERENCES `courses` (`idCourse`) ON DELETE CASCADE,
  CONSTRAINT `userCourses_usuarios_FK` FOREIGN KEY (`user`) REFERENCES `usuarios` (`userId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userCourses`
--

LOCK TABLES `userCourses` WRITE;
/*!40000 ALTER TABLE `userCourses` DISABLE KEYS */;
INSERT INTO `userCourses` VALUES
(1,1,3,NULL,'No comentado'),
(2,2,4,NULL,'No comentado'),
(3,3,5,NULL,'No comentado'),
(4,4,6,NULL,'No comentado'),
(5,5,3,NULL,'No comentado'),
(6,6,4,NULL,'No comentado'),
(7,7,5,NULL,'No comentado');
/*!40000 ALTER TABLE `userCourses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `userId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `names` varchar(30) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password_hash` text NOT NULL,
  `googleUserId` char(20) DEFAULT NULL,
  `userType` enum('Administrador','Coordinador','Profesor') NOT NULL,
  `coordinador` int(10) unsigned DEFAULT NULL,
  `lastName` varchar(50) NOT NULL,
  `status` enum('Activo','Inactivo','Pendiente') NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (`userId`),
  KEY `usuarios_coordinador_FK` (`coordinador`),
  CONSTRAINT `usuarios_coordinador_FK` FOREIGN KEY (`coordinador`) REFERENCES `usuarios` (`userId`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES
(1,'Admin','admin@example.com','password_hash_admin',NULL,'Administrador',NULL,'User','Activo'),
(2,'Coord','coord@example.com','password_hash_coord',NULL,'Coordinador',NULL,'User','Inactivo'),
(3,'Prof','smith@example.com','password_hash_prof',NULL,'Profesor',NULL,'Smith','Pendiente'),
(4,'Prof','brown@example.com','password_hash_brown',NULL,'Profesor',NULL,'Brown','Pendiente'),
(5,'Prof','johnson@example.com','password_hash_johnson',NULL,'Profesor',NULL,'Johnson','Activo'),
(6,'Prof','king@example.com','password_hash_king',NULL,'Profesor',NULL,'King','Activo');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `honeycumb`.`after_usuario_update`
AFTER UPDATE ON `usuarios`
FOR EACH ROW
BEGIN
    INSERT INTO `registroAuditoria` 
    (`tipoMovimiento`, `nombreUsuario`, `fechaMovimiento`, `usuarioQueRealizoAccion`)
    VALUES ('UPDATE', NEW.names, NOW(), CURRENT_USER());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `honeycumb`.`after_usuario_delete`
AFTER DELETE ON `usuarios`
FOR EACH ROW
BEGIN
    INSERT INTO `registroAuditoria` 
    (`tipoMovimiento`, `nombreUsuario`, `fechaMovimiento`, `usuarioQueRealizoAccion`)
    VALUES ('DELETE', OLD.names, NOW(), CURRENT_USER());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-04  3:44:43

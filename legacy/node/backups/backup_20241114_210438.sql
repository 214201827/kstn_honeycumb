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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registroAuditoria`
--

LOCK TABLES `registroAuditoria` WRITE;
/*!40000 ALTER TABLE `registroAuditoria` DISABLE KEYS */;
INSERT INTO `registroAuditoria` VALUES
(1,'DELETE','David','Desconocido','root@localhost','2024-11-12 21:45:24'),
(2,'DELETE','David','Desconocido','root@localhost','2024-11-12 21:46:10');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `studentCourses`
--

LOCK TABLES `studentCourses` WRITE;
/*!40000 ALTER TABLE `studentCourses` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userCourses`
--

LOCK TABLES `userCourses` WRITE;
/*!40000 ALTER TABLE `userCourses` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES
(3,'David','d.munguia@gigapro.mx','$2b$10$0qQHwcI5lTbCVewuSZigO.CbpW.pFMbiTW9vYcXG.FB4uTjPhL3N.',NULL,'Administrador',NULL,'Munguía','Activo');
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

-- Dump completed on 2024-11-14 21:04:38

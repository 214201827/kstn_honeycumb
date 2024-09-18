CREATE DATABASE honeycumb;

USE honeycumb;


-- Definir tabla de usuarios

CREATE TABLE usuarios (
    idUsuario INT UNSIGNED NOT_NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    names VARCHAR(30) NOT_NULL,
    email VARCHAR(50) NOT_NULL,
    password_hash CHAR(256) NOT_NULL,
    googleUserId CHAR(20),
    userId INT UNSIGNED,
    userType INT UNSIGNED NOT_NULL,
    courseId INT UNSIGNED,
    sessionId INT UNSIGNED
);
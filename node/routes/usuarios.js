const express = require('express');
const router = express.Router();
const usuariosController = require('../controllers/userController.js');

// Obtener todos los usuarios
router.get('/usuarios', usuariosController.obtenerUsuarios);

// Crear un nuevo usuario
router.post('/crearUsuario', usuariosController.crearUsuario);

// Desactivar un usuario por email
router.put('/desactivarUsuario', usuariosController.desactivarUsuario);

module.exports = router;

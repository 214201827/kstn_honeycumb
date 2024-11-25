const express = require('express');
const router = express.Router();
const usuariosController = require('../controllers/userController.js');
const auth = require('../middleware/auth');


// Obtener todos los usuarios
router.get('/', usuariosController.obtenerUsuarios);

// Crear un nuevo usuario
router.post('/crear', usuariosController.crearUsuario);

// Desactivar un usuario por email
router.put('/desactivar', usuariosController.desactivarUsuario);

// Iniciar sesión
router.post('/login', usuariosController.loginUsuario);

// Asignar usuario a coordinador
router.post('/asignarUsuario', usuariosController.assignUserToCoordinator);

// Obtener usuarios asignados a coordinador
router.get('/usuariosCoord', usuariosController.getUsersByCoordinator);






module.exports = router;

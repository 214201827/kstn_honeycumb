const express = require('express');
const router = express.Router();
const backupController = require('../controllers/backupController');

// Descargar el respaldo más reciente
router.get('/', backupController.descargarRespaldo);

module.exports = router;

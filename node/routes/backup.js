const express = require('express');
const router = express.Router();
const backupController = require('../controllers/backupController');

// Descargar el respaldo más reciente
router.get('/download-backup', backupController.descargarRespaldo);

module.exports = router;

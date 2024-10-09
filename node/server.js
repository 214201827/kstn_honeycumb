const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();

// Ruta para descargar el respaldo más reciente
app.get('/download-backup', (req, res) => {
  const backupDir = '/backups';  // Carpeta donde se guardan los respaldos

  // Leer los archivos del directorio de backups
  fs.readdir(backupDir, (err, files) => {
    if (err) {
      console.error('Error leyendo la carpeta de respaldos:', err);
      return res.status(500).send('Error al leer la carpeta de respaldos.');
    }

    if (files.length === 0) {
      return res.status(404).send('No se encontraron respaldos.');
    }

    // Encontrar el archivo más reciente
    const latestBackup = files
      .map(file => ({
        file,
        time: fs.statSync(path.join(backupDir, file)).mtime.getTime()
      }))
      .sort((a, b) => b.time - a.time)[0].file;

    const filePath = path.join(backupDir, latestBackup);

    // Enviar el archivo para su descarga
    res.download(filePath, latestBackup, (err) => {
      if (err) {
        console.error('Error al enviar el archivo:', err);
        res.status(500).send('Error al descargar el respaldo.');
      }
    });
  });
});

const port = 3000;
app.listen(port, () => {
  console.log(`Servidor de respaldo escuchando en el puerto ${port}`);
});
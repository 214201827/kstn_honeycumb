// server.js
const express = require('express');
const { exec } = require('child_process');
const path = require('path');

const app = express();

app.get('/backup', (req, res) => {
  exec('docker exec ./backup.sh', (error, stdout, stderr) => {
    if (error) {
      console.error(`Error ejecutando el respaldo: ${error}`);
      return res.status(500).send('Error en el respaldo.');
    }

    const backupFile = `./backups/backup-${new Date().toISOString().slice(0, 19).replace(/:/g, "")}.sql`;
    res.download(backupFile, (err) => {
      if (err) {
        console.error('Error enviando el archivo de respaldo: ', err);
        res.status(500).send('Error descargando el respaldo.');
      }
    });
  });
});

const port = 3000;
app.listen(port, () => {
  console.log(`Servidor de respaldo escuchando en el puerto ${port}`);
});
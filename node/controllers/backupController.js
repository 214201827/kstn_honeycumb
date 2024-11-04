const fs = require('fs');
const path = require('path');

// Descargar el respaldo más reciente
exports.descargarRespaldo = (req, res) => {
  const backupDir = '/backups';

  fs.readdir(backupDir, (err, files) => {
    if (err) {
      console.error('Error leyendo la carpeta de respaldos:', err);
      return res.status(500).send('Error al leer la carpeta de respaldos.');
    }

    if (files.length === 0) {
      return res.status(404).send('No se encontraron respaldos.');
    }

    const latestBackup = files
      .map(file => ({
        file,
        time: fs.statSync(path.join(backupDir, file)).mtime.getTime()
      }))
      .sort((a, b) => b.time - a.time)[0].file;

    const filePath = path.join(backupDir, latestBackup);

    res.download(filePath, latestBackup, (err) => {
      if (err) {
        console.error('Error al enviar el archivo:', err);
        res.status(500).send('Error al descargar el respaldo.');
      }
    });
  });
};

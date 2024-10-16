const express = require('express');
const fs = require('fs');
const path = require('path');
const port = 3000;
const app = express();
const mysql = require('mysql');

// Credenciales de la BD

const db = mysql.createConnection({
  host: 'db',
  user: 'keystone',
  password: 'keystone',
  database: 'honeycumb'
});

// Conectarse a la BD
db.connect(err => {
  if (err) throw err;
  console.log('Backend conectado a la base de datos.');
});



// Ruta para obtener todos los usuarios
app.get('/usuarios', (req, res) => {
  const query = `SELECT names, lastName, email, activo FROM usuarios`;

  db.query(query, (err, results) => {
      if (err) {
          console.error(err);
          return res.status(500).send('Error al obtener los usuarios');
      }

      res.json(results); // Devolvemos la lista de usuarios en formato JSON
  });
});

// Iniciar el servidor
app.listen(port, () => {
  console.log('Servidor escuchando en puerto 3000');
});




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

/*
app.listen(port, () => {
  console.log(`Servidor de respaldo escuchando en el puerto ${port}`);
});*/



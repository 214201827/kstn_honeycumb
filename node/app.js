const express = require('express');
const app = express();
const port = 3000;
const cors = require('cors');

// Middlewares
app.use(express.json());
app.use(cors());

// Rutas
const usuariosRoutes = require('./routes/usuarios');
const backupRoutes = require('./routes/backup');

app.use('/usuarios', usuariosRoutes);
app.use('/download-backup', backupRoutes);

// Iniciar el servidor
app.listen(port, () => {
  console.log(`Servidor escuchando en puerto ${port}`);
});

const express = require('express');
const app = express();
const port = 3000;
const cors = require('cors');

// Middlewares
app.use(express.json());
app.use(cors());

// CORS con credenciales-

/* 

const cors = require('cors');
app.use(cors({
    origin: 'http://localhost', // Cambia al dominio de tu frontend
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true
}));

*/



// Rutas
const usuariosRoutes = require('./routes/usuarios');
const backupRoutes = require('./routes/backup');
const credentialsRoutes = require('./routes/credentials');
const studentsRoutes = require('./routes/students');

app.use('/usuarios', usuariosRoutes);
app.use('/download-backup', backupRoutes);
app.use('/credentials', credentialsRoutes);
app.use('/students', studentsRoutes);

// Iniciar el servidor
app.listen(port, () => {
  console.log(`Servidor escuchando en puerto ${port}`);
});

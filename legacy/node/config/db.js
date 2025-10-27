const mysql = require('mysql2');

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

module.exports = db;

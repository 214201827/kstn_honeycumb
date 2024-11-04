const db = require('../config/db');
const bcrypt = require('bcrypt');

// Obtener todos los usuarios
exports.obtenerUsuarios = (req, res) => {
  const query = `SELECT names, lastName, email, status, userType FROM usuarios`;

  db.query(query, (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).send('Error al obtener los usuarios');
    }

    res.json(results);
  });
};

// Crear un nuevo usuario
exports.crearUsuario = async (req, res) => {
  const { names, email, password, userType, lastName } = req.body;

  if (!names || !email || !password || !userType || !lastName) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  try {
    const password_hash = await bcrypt.hash(password, 10);

    const query = `
      INSERT INTO usuarios (names, email, password_hash, userType, lastName)
      VALUES (?, ?, ?, ?, ?)
    `;

    db.query(query, [names, email, password_hash, userType, lastName], (err, results) => {
      if (err) {
        console.error('Error al insertar el usuario:', err);
        return res.status(500).json({ error: 'Error al insertar el usuario' });
      }

      res.status(201).json({ message: 'Usuario creado exitosamente', userId: results.insertId });
    });
  } catch (error) {
    console.error('Error al crear el usuario:', error);
    res.status(500).json({ error: 'Error al crear el usuario' });
  }
};

// Desactivar un usuario por email
exports.desactivarUsuario = (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ error: 'Se requiere el correo electrónico del usuario' });
  }

  const getUserIdQuery = `SELECT getUserIdFromEmail(?) as userId`;

  db.query(getUserIdQuery, [email], (err, results) => {
    if (err) {
      console.error('Error al obtener el userId:', err);
      return res.status(500).json({ error: 'Error al obtener el userId del usuario' });
    }

    const userId = results[0]?.userId;

    if (!userId) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    const updateStatusQuery = `UPDATE usuarios SET status = 'Inactivo' WHERE userId = ?`;

    db.query(updateStatusQuery, [userId], (err, results) => {
      if (err) {
        console.error('Error al desactivar el usuario:', err);
        return res.status(500).json({ error: 'Error al desactivar el usuario' });
      }

      if (results.affectedRows === 0) {
        return res.status(404).json({ error: 'Usuario no encontrado o ya está inactivo' });
      }

      res.status(200).json({ message: 'Usuario desactivado exitosamente' });
    });
  });
};

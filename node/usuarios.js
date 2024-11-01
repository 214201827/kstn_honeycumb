// Ruta para obtener todos los usuarios
app.get('/usuarios', (req, res) => {
    const query = `SELECT names, lastName, email, status, userType FROM usuarios`;
  
    db.query(query, (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Error al obtener los usuarios');
        }
  
        res.json(results); // Devolvemos la lista de usuarios en formato JSON
    });
  });
  
  
// Ruta para desactivar un usuario por email
app.put('/usuarios/desactivar', (req, res) => {
    const { email } = req.body;
  
    if (!email) {
      return res.status(400).json({ error: 'Se requiere el correo electrónico del usuario' });
    }
  
    // Llamar a la función en la base de datos para obtener el userId por email
    const getUserIdQuery = `SELECT getUserIdFromEmail(?) as userId`;
  
    connection.query(getUserIdQuery, [email], (err, results) => {
      if (err) {
        console.error('Error al obtener el userId:', err);
        return res.status(500).json({ error: 'Error al obtener el userId del usuario' });
      }
  
      const userId = results[0]?.userId;
  
      if (!userId) {
        return res.status(404).json({ error: 'Usuario no encontrado' });
      }
  
      // Actualizar el estado del usuario a 'Inactivo'
      const updateStatusQuery = `UPDATE usuarios SET status = 'Inactivo' WHERE userId = ?`;
  
      connection.query(updateStatusQuery, [userId], (err, results) => {
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
  });
  
// Ruta para crear un nuevo usuario
app.post('/usuario', async (req, res) => {
    const { names, email, password, userType, lastName } = req.body;
  
    // Validar los campos requeridos
    if (!names || !email || !password || !userType || !lastName) {
      return res.status(400).json({ error: 'Faltan campos obligatorios' });
    }
  
    try {
      // Hash de la contraseña
      const password_hash = await bcrypt.hash(password, 10);
  
      // Query para insertar el nuevo usuario
      const query = `
        INSERT INTO usuarios (names, email, password_hash, userType, lastName)
        VALUES (?, ?, ?, ?, ?)
      `;
      
      // Ejecutar la query
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
  });
  
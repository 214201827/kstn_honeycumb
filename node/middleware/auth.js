// middleware/auth.js

const jwt = require('jsonwebtoken');

exports.verifyToken = (req, res, next) => {
  const token = req.headers['authorization'];

  if (!token) {
    return res.status(403).json({ error: 'Se requiere un token de autenticación' });
  }

  try {
    const bearerToken = token.startsWith('Bearer ') ? token.slice(7, token.length) : token;
    const decoded = jwt.verify(bearerToken, process.env.JWT_SECRET || 'tu_clave_secreta_super_segura');
    req.user = decoded;
    next();
  } catch (err) {
    console.error('Error al verificar el token:', err);
    res.status(401).json({ error: 'Token inválido' });
  }
};

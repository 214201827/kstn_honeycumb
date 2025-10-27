import sqlite3 from 'sqlite3';
import express, { json } from 'express';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(json()); // for parsing application/json

let db = new sqlite3.Database('db.db', (err) => {
    if (err) {
        return console.error(err.message);
    }
    console.log('Connected to the in-memory SQlite database.');
});

db.run(`CREATE TABLE IF NOT EXISTS usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
)`);

app.listen(3000, () => {
    console.log("Server running on port 3000");
});

app.post("/regUsr", (req, res) => {
    const { nombre, email, password } = req.body;

    // depure
   // console.log({ nombre, email, password });

    if (!nombre || !email || !password) {
        return res.status(400).json({ "message": "CAMPO(S) VACIO(S)." });
    }

    // Crear instancia de usuario

    db.run(`INSERT INTO usuarios(nombre, email, password) VALUES(?, ?, ?)`,
        [nombre, email, password],
        function (err) {
        if (err) {
            return res.status(500).json({
                "message": `Error al insertar los datos: ${err.message}`
            });
        }
        res.status(200).json({
            "message": `Se ha insertado un nuevo registro con ID: ${this.lastID}`
        });
    });
});

/*
// Vista por defecto
app.get("/", (req, res, next) => {
    res.json({ "message": "holaa" });
});
*/
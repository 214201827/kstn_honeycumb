# Usar la imagen oficial de Node.js
FROM node:18

# Establecer el directorio de trabajo en el contenedor
WORKDIR /usr/src/app

# Copiar package.json y package-lock.json al contenedor
COPY package*.json ./

# Instalar las dependencias del proyecto
RUN npm install
RUN npm install mysql2 cors bcrypt express body-parser cookie-parser googleapis

# Copiar el resto de los archivos del proyecto
COPY . .

# Exponer el puerto 3000 para el servidor backend
EXPOSE 3000

# Comando para ejecutar el servidor
CMD ["node", "server.js"]

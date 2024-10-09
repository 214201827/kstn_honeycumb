# Usa una imagen oficial de Node.js como base
FROM node:18-alpine

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Copia el archivo package.json y package-lock.json
COPY package*.json ./

# Instala las dependencias de la aplicación
RUN npm install --only=production

# Copia el resto del código de la aplicación
COPY . .

# Expone el puerto que utilizará la aplicación (puerto 3000 en este caso)
EXPOSE 3000

# Define el comando para ejecutar la aplicación
CMD [ "node", "app.js" ]

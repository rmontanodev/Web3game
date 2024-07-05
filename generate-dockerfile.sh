#!/bin/bash

NODE_VERSION=$(jq -r '.engines.node' package.json | grep -o -E '[0-9]+\.[0-9]+\.[0-9]+')

if [ -z "$NODE_VERSION" ]; then
  echo "No se pudo encontrar la versión de Node.js en package.json"
  exit 1
fi

cat <<EOF > Dockerfile

# Usa una imagen base oficial de Node.js
FROM node:$NODE_VERSION

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el archivo package.json y package-lock.json al directorio de trabajo
COPY package*.json ./

# Instala las dependencias del proyecto
RUN npm ci --only=production

# Copia el resto del código de la aplicación al directorio de trabajo
COPY . .

# Expone el puerto que usa la aplicación (cambia esto según sea necesario)
EXPOSE 3000

# Define el comando de inicio para el contenedor
CMD [ "node", "src/index.js" ]
EOF

echo "Dockerfile generado con la versión de Node.js $NODE_VERSION"

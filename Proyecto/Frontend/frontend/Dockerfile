# Stage 1 — build con Node (Vite)
FROM node:20-alpine AS build
WORKDIR /app

# Instala dependencias (usa package*.json)
COPY package*.json ./
RUN npm ci

# Copia el resto y ejecuta build — setea VITE_API_BASE si lo necesitas en tiempo de build
COPY . .

# Si quieres inyectar VITE_API_BASE en build puedes usar ARG/ENV, por defecto usamos localhost:8080/api
ARG VITE_API_BASE=http://localhost:8080/api
ENV VITE_API_BASE=${VITE_API_BASE}

# Ejecutar build (genera ./dist)
RUN npm run build

# Stage 2 — nginx para servir los archivos estáticos
FROM nginx:stable-alpine AS prod
LABEL maintainer="nathaly"

# Quitamos default.conf y copiamos el nuestro
RUN rm -f /etc/nginx/conf.d/default.conf
COPY nginx/frontend.conf /etc/nginx/conf.d/default.conf

# Copiar el resultado del build al root de nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Exponer puerto 80 (lo mapearás en docker-compose)
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

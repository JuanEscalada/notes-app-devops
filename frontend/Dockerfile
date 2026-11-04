# Etapa 1: compilar Angular
FROM node:24.15-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

RUN npm run build

# Etapa 2: servir los archivos compilados
FROM nginx:1.30-alpine

COPY --from=build /app/dist/notes-web/browser/ /usr/share/nginx/html/

EXPOSE 80
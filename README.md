# notes-app

Aplicación de notas compuesta por una API en Python (Flask) con MongoDB 8.0 y un frontend en Angular.

- `api/`: API en Flask. Las pruebas corren con `pytest`
- `frontend/`: aplicación Angular 22 que consume la API en `/api/v1/notes`. Requiere Node.js 22 o 24 LTS. Para buildear: `npm ci` y `npm run build`.
- `diagnostics/`: despliegue con Docker Compose.


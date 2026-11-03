# Estado inicial del proyecto

## Entorno

- Sistema operativo: Debian 13
- Python: 3.13.5
- Node.js: 24.15.0
- npm: 11.12.1

## Backend

Comando:

    cd api
    python -m pytest -v

Resultado: 5 tests pasando

- test_health: PASSED
- test_create_and_list: PASSED
- test_title_is_required: PASSED
- test_get_and_delete: PASSED
- test_invalid_id: PASSED

Observaciones:
- Los tests utilizan mongomock.
- No requieren una instancia real de MongoDB.

## Frontend

Comandos:

    cd frontend
    npm ci
    npm run build

Resultado: Exitoso

Directorio de salida: dist/notes-web/

## Pendiente de verificar

- Conexión real con MongoDB 8.0.
- Autenticación en MongoDB.
- Comunicación frontend/API.
- Despliegue con Docker Compose.
- Despliegue en Kubernetes.

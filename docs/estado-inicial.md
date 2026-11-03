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

Observaciones:
- Los tests utilizan mongomock.
- No requieren una instancia real de MongoDB.

## Frontend

Comandos:

    cd frontend
    npm ci
    npm run build

Resultado: Exitoso

Directorio de salida: dist/

## Limitaciones de la verificación

- No se comprobó la conexión con MongoDB real.
- No se comprobó el funcionamiento integrado con Docker Compose.
- No se realizó un despliegue en Kubernetes.

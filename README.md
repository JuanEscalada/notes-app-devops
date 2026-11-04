# Notes App — Desafío técnico DevOps

Aplicación de gestión de notas desarrollada con **Flask, Angular 22 y MongoDB 8.0**.

## Arquitectura

- **Angular 22:** interfaz de usuario compilada para producción.
- **Nginx:** servidor de archivos estáticos y proxy reverso hacia la API.
- **Flask + Gunicorn:** API REST para crear, listar, consultar y eliminar notas.
- **MongoDB 8.0:** almacenamiento persistente con autenticación.

Nginx es el único componente expuesto al host. La API y MongoDB se comunican mediante las redes internas de Docker Compose o Kubernetes.

## Requisitos

Para Docker Compose:
- Docker Engine
- Docker Compose v2

Para Kubernetes:
- Docker Engine
- kind
- kubectl
- Un clúster con StorageClass predeterminada

Para desarrollo local:
- Python 3.13
- nvm y Node.js 24.15.0
- npm

## Ejecución con Docker Compose

Desde la raíz del repositorio:

```bash
cp .env.example .env
```

Modificar `.env` para establecer las credenciales locales de MongoDB.

Para las pruebas locales se recomienda generar contraseñas hexadecimales con openssl rand -hex 24. Esto evita caracteres que requieren codificación especial dentro de la URI de MongoDB. No se deben publicar las credenciales reales ni el archivo .env.

Iniciar los servicios:

```bash
docker compose --env-file .env \
  -p notes-app-local \
  -f diagnostics/compose.yaml \
  up -d --build --wait
```

La aplicación estará disponible en `http://localhost:8080`.

Para comprobar el funcionamiento:

```bash
./scripts/smoke-test.sh
```

Para comprobar también la persistencia después de recrear los contenedores:

```bash
./scripts/smoke-test.sh --restart-compose
```

Detener el entorno sin eliminar los datos:

```bash
docker compose --env-file .env \
  -p notes-app-local \
  -f diagnostics/compose.yaml down
```

## Ejecución en Kubernetes local

Crear el clúster:

```bash
kind create cluster --name notes-app
```

Crear el Namespace:

```bash
kubectl apply -f k8s/00-namespace.yaml
```

Generar las credenciales a partir del archivo local `.env`:

```bash
kubectl -n notes-app create secret generic \
  notes-db-credentials \
  --from-env-file=.env \
  --dry-run=client -o yaml | kubectl apply -f -
```

Aplicar los manifiestos:

```bash
kubectl apply -f k8s/
```

Comprobar los Deployments:

```bash
kubectl -n notes-app rollout status deployment/mongo
kubectl -n notes-app rollout status deployment/api
kubectl -n notes-app rollout status deployment/frontend
```

Exponer temporalmente la aplicación:

```bash
kubectl -n notes-app port-forward svc/proxy 18080:80
```

En otra terminal, ejecutar:

```bash
BASE_URL=http://127.0.0.1:18080 \
  ./scripts/smoke-test.sh
```

El despliegue utiliza imágenes públicas de GHCR identificadas por sus digests SHA256, permitiendo reproducir la misma versión sin reconstruirlas.

## Integración continua

GitHub Actions ejecuta automáticamente:

- Las pruebas de Flask con pytest.
- La compilación del frontend Angular.
- La construcción de ambas imágenes Docker.
- La publicación de las imágenes en GHCR desde la rama `main`.

Imágenes públicas:

- `ghcr.io/juanescalada/notes-api:latest`
- `ghcr.io/juanescalada/notes-web:latest`

También se publican imágenes identificadas mediante el hash del commit.

## Desarrollo local

### Backend

```bash
cd api
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-dev.txt
python -m pytest -v
```

Las pruebas utilizan `mongomock` y no requieren MongoDB real.

Para ejecutar el servidor de desarrollo se necesita configurar una instancia de MongoDB accesible mediante `MONGO_URI`.

### Frontend

```bash
nvm use
cd frontend
npm ci
npm start
```

Para generar el build de producción:

```bash
npm run build
```

## Diagnóstico

El archivo `diagnostics/compose-broken.yml` conserva la configuración defectuosa original.

La configuración corregida está en `diagnostics/compose.yaml`.

Los errores identificados y las soluciones aplicadas están documentados en `diagnostics/README.md`.

## Alcance y limitaciones

El despliegue fue preparado para ejecución local, como solicita el desafío.

No incluye alta disponibilidad de MongoDB, TLS, Ingress público, backups automatizados ni gestión externa de secretos.

La configuración de base de datos utiliza una única instancia con almacenamiento persistente. Para un entorno productivo real sería necesario evaluar una arquitectura con mayor disponibilidad, gestión de credenciales, monitoreo y backups.
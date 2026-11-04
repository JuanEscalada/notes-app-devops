# Pruebas de integración

Las pruebas verifican la comunicación entre Nginx, Flask y MongoDB, utilizando una base de datos real.

## Requisitos

- Bash, curl y Python 3.
- Los tres servicios desplegados y disponibles.
- Acceso HTTP a la aplicación.

## Docker Compose

Con la aplicación ejecutándose en `http://127.0.0.1:8080`:

```bash
./scripts/smoke-test.sh
```

Para comprobar también la persistencia después de eliminar y recrear los contenedores, sin eliminar los volúmenes:

```bash
./scripts/smoke-test.sh --restart-compose
```

Esta opción utiliza el proyecto Compose `notes-app-local`.

## Kubernetes

Primero exponer temporalmente el Service:

```bash
kubectl -n notes-app port-forward svc/proxy 18080:80
```

En otra terminal:

```bash
BASE_URL=http://127.0.0.1:18080 ./scripts/smoke-test.sh
```

No utilizar `--restart-compose` para Kubernetes.

## Comportamientos verificados

- Crear una nota y recuperar su identificador.
- Consultar la nota creada.
- Comprobar que aparece en el listado.
- Rechazar una nota sin título con HTTP 400.
- Eliminar la nota con HTTP 204.
- Confirmar que ya no existe mediante HTTP 404.
- Opcionalmente, verificar persistencia después de recrear los contenedores Compose.

Estas pruebas complementan los tests de pytest, que utilizan `mongomock` en lugar de MongoDB real.
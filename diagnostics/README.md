# Diagnostics: Deployment original contra el corregido

- `compose-broken.yml` se conserva sin modificar y que las correcciones se realizaron progresivamente para facilitar su diagnóstico.
- `compose.yaml` Los cambios para tener un compose funcional se realizan sobre este archivo nuevo

## Problematicas encontradas

| Problema original | Corrección |
|---|---|
| Healthcheck ejecutaba mongo | Sustituido por mongosh |
| Hostname db inexistente | Reemplazado por mongo |
| Autenticación fallida | Agregado authSource=admin |
| /healthz inexistente | Corregido a /health |
| Nginx apuntaba al puerto 5000 | Corregido a 8000 |
| Flask ignoraba MONGO_URI | Configuración mediante variables de entorno |
| Logs en una ruta fija | Configuración compatible con stderr |
| Imágenes de aplicación inexistentes | Agregados Dockerfiles de producción |
| Frontend dependía del build local | Incorporado multi-stage build |
| Contraseñas hardcodeadas | Externalizadas mediante .env |
| Inicialización dependiente del entorno | Script reutilizable con variables de entorno |


## Para correr desde el root del proyecto:

```bash
cp .env.example .env
# Cambiar passwords placeholder en .env antes de ejecutar
docker compose -f diagnostics/compose.yaml up --build -d --wait
```

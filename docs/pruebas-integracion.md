#Para ejecutar:

./scripts/smoke-test.sh 

y garantizando que todo funcione incluso bajando y levantando los servicios:

./scripts/smoke-test.sh --restart-compose

#Pruebas:

- Crear y recuperar una nota

- Encontrarla en el listado

- Rechazar una nota inválida con HTTP 400

- Conservar la nota después de recrear los contenedores

- Eliminar la nota con HTTP 204 y verificar HTTP 404
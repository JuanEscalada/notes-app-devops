#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_URL="${BASE_URL:-http://127.0.0.1:8080}"
API="${BASE_URL%/}/api/v1/notes"

if [[ "${1:-}" != "" && "${1:-}" != "--restart-compose" ]]; then
  echo "Uso: $0 [--restart-compose]" >&2
  exit 2
fi

compose() {
  docker compose --env-file "$ROOT/.env" \
    -p notes-app-local -f "$ROOT/diagnostics/compose.yaml" "$@"
}

verificar_nota() {
  curl -fsS "$API/$note_id" | python3 -c '
import json, sys
nota = json.load(sys.stdin)
assert nota["title"] == "Prueba automatizada"
assert nota["text"] == "Creada desde smoke-test"
'
}

echo "1. Crear nota"

creada=$(curl -fsS -X POST "$API" \
  -H "Content-Type: application/json" \
  -d '{"title":"Prueba automatizada","text":"Creada desde smoke-test"}')

note_id=$(printf '%s' "$creada" |
  python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])')

echo "Nota creada: $note_id"

echo "2. Consultar nota"
verificar_nota

echo "3. Comprobar listado"
curl -fsS "$API" | python3 -c '
import json, sys
notes = json.load(sys.stdin)
assert any(note["id"] == sys.argv[1] for note in notes)
' "$note_id"

echo "4. Comprobar validación"
status=$(curl -sS -o /dev/null -w '%{http_code}' \
  -X POST "$API" \
  -H "Content-Type: application/json" \
  -d '{"text":"sin título"}')

[[ "$status" == "400" ]] || {
  echo "Se esperaba HTTP 400, llegó $status" >&2
  exit 1
}

if [[ "${1:-}" == "--restart-compose" ]]; then
  echo "5. Recrear contenedores conservando volúmenes"

  [[ -f "$ROOT/.env" ]] || {
    echo "No existe .env" >&2
    exit 1
  }

  compose down
  compose up -d --wait

  echo "Comprobar persistencia"
  verificar_nota
fi

echo "6. Borrar nota"
status=$(curl -sS -o /dev/null -w '%{http_code}' \
  -X DELETE "$API/$note_id")

[[ "$status" == "204" ]] || {
  echo "Se esperaba HTTP 204, llegó $status" >&2
  exit 1
}

echo "7. Confirmar eliminación"
status=$(curl -sS -o /dev/null -w '%{http_code}' \
  "$API/$note_id")

[[ "$status" == "404" ]] || {
  echo "Se esperaba HTTP 404, llegó $status" >&2
  exit 1
}

echo "OK: pruebas de integración completadas"

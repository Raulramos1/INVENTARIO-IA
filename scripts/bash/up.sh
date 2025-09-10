#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."

if [ -f ".env.local" ]; then
  envfile=".env.local"
else
  envfile=".env"
fi

echo "Usando $envfile"
docker compose --env-file "$envfile" up -d
docker compose ps

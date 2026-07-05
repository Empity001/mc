#!/usr/bin/env bash
set -euo pipefail

mkdir -p /data/plugins/Typewriter/extensions

# Archivos base: se copian solo si todavía no existen en el volumen.
for file in eula.txt server.properties ops.json whitelist.json; do
  if [ -f "/app/server/$file" ] && [ ! -f "/data/$file" ]; then
    cp "/app/server/$file" "/data/$file"
  fi
done

# Paper y los plugins sí se actualizan en cada despliegue.
if [ -f /app/server/paper.jar ]; then
  cp -f /app/server/paper.jar /data/paper.jar
fi

if compgen -G "/app/server/plugins/*.jar" > /dev/null; then
  cp -f /app/server/plugins/*.jar /data/plugins/
fi

if compgen -G "/app/server/plugins/Typewriter/extensions/*.jar" > /dev/null; then
  cp -f /app/server/plugins/Typewriter/extensions/*.jar /data/plugins/Typewriter/extensions/
fi

# Copia inicial de la configuración de Typewriter.
if [ -f /app/server/plugins/Typewriter/config.yml ] && [ ! -f /data/plugins/Typewriter/config.yml ]; then
  cp /app/server/plugins/Typewriter/config.yml /data/plugins/Typewriter/config.yml
fi

# Railway asigna el dominio después del primer despliegue.
# Esta variable permite actualizar hostname sin editar manualmente el volumen.
if [ -n "${TYPEWRITER_HOSTNAME:-}" ] && [ -f /data/plugins/Typewriter/config.yml ]; then
  sed -i -E "s|^hostname:.*|hostname: \"${TYPEWRITER_HOSTNAME}\"|" /data/plugins/Typewriter/config.yml
fi

cd /data

if [ ! -f paper.jar ]; then
  echo "ERROR: falta server/paper.jar en el repositorio."
  exit 1
fi

exec java -Xms512M -Xmx"${MEMORY:-2G}" -jar paper.jar --nogui

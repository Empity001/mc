#!/usr/bin/env bash
set -euo pipefail

mkdir -p /data/plugins/Typewriter/extensions

# Archivos base: se copian solo si todavía no existen en el volumen.
for file in eula.txt server.properties ops.json whitelist.json; do
  if [ -f "/app/server/$file" ] && [ ! -f "/data/$file" ]; then
    cp "/app/server/$file" "/data/$file"
  fi
done

# Descargar Paper automáticamente si no existe
if [ ! -f /data/paper.jar ]; then
  echo "Descargando Paper 1.21.11..."
  curl -L "https://fill.papermc.io/v3/projects/paper/versions/1.21.11/builds/latest/downloads/paper-1.21.11.jar" -o /data/paper.jar
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

exec java -Xms512M -Xmx"${MEMORY:-2G}" -jar paper.jar --nogui

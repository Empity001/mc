# Typewriter en Railway — plantilla

Esta plantilla prepara un servidor Paper temporal para editar historias de Typewriter.

## 1. Añade estos archivos antes de subir a GitHub

- `server/paper.jar`
- `server/plugins/Typewriter-0.8.0.jar`
- `server/plugins/packetevents-spigot-....jar`
- `server/plugins/Typewriter/extensions/BasicExtension.jar`

Añade también cualquier otra extensión de Typewriter 0.8.0 que uses.

## 2. Configura tu usuario

Abre `server/ops.json` y `server/whitelist.json`.

Reemplaza:

`PEGA-AQUI-TU-UUID-DE-JAVA`

por tu UUID real. Puedes copiarlo del archivo `usercache.json` de tu servidor actual.

Si tu nombre no es `EmptyTRB`, cámbialo en ambos archivos.

## 3. Sube la carpeta completa a un repositorio de GitHub

Railway detectará automáticamente el `Dockerfile`.

## 4. En Railway

1. New Project → Deploy from GitHub Repo.
2. Añade un volumen y móntalo en `/data`.
3. Añade la variable `MEMORY=2G`.
4. Crea dos dominios públicos:
   - target port `8080` para el panel;
   - target port `9092` para WebSocket.
5. Crea un TCP Proxy hacia el puerto interno `25565`.
6. Añade `TYPEWRITER_HOSTNAME` con el dominio del panel y vuelve a desplegar.

## 5. Conexión

Entra al servidor usando la dirección del TCP Proxy.

Ejecuta:

`/typewriter connect`

Toma el token del enlace generado y construye la URL así:

`https://DOMINIO-DEL-PANEL/#/connect?host=DOMINIO-DEL-WEBSOCKET&port=443&token=TOKEN`

## 6. Recuperar tus archivos

Los datos persistentes quedan en `/data/plugins/Typewriter`.

Con Railway CLI:

`railway volume files download /plugins/Typewriter ./Typewriter-descargado`

Después copia el contenido necesario al servidor real con el servidor apagado.

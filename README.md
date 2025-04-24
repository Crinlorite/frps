# 🧠 FRPS en Fly.io para exponer un servidor Bedrock desde casa

Este repositorio contiene la configuración necesaria para desplegar un servidor `frps` (Fast Reverse Proxy - Server) en [Fly.io](https://fly.io), permitiendo redirigir conexiones externas a servicios locales en tu red doméstica a través de `frpc`.

Ideal para exponer un servidor **Minecraft Bedrock** corriendo en un equipo detrás de NAT o sin IP pública.

---

## 🚀 Características

- Servidor `frps` ejecutado en Fly.io (con Docker o imagen remota)
- Soporte para **UDP y TCP** (con puertos configurables)
- Preparado para exponer el puerto **19132 UDP**, usado por Minecraft Bedrock
- Compatible con servidores corriendo en **Docker o en local**
- Sin necesidad de abrir puertos en tu router

---

## 📁 Estructura del proyecto

```txt
.
├── fly.toml          # Configuración para Fly.io
├── frps.ini          # Configuración del servidor frps
└── README.md         # Este documento
```

---

## 🛠️ fly.toml básico

```toml
app = "bedcrin"
primary_region = "lhr"

[build]
image = "ghcr.io/fatedier/frps:v0.58.1"

[[services]]
  internal_port = 7000
  protocol = "tcp"

  [[services.ports]]
    port = 7000
    handlers = []

  [[services.tcp_checks]]
    interval = 10000
    timeout = 2000

[[services]]
  internal_port = 7000
  protocol = "udp"

  [[services.ports]]
    port = 19132

[[vm]]
  cpu_kind = "shared"
  cpus = 1
  memory_mb = 256
```

---

## 🔧 Configuración `frps.ini` (opcional si usas imagen preconfigurada)

```ini
[common]
bind_port = 7000
bind_udp_port = 7000
```

---

## 💻 Configuración de `frpc` en tu equipo (frpc.json)

```json
{
  "serverAddr": "bedcrin.fly.dev",
  "serverPort": 7000,
  "proxies": [
    {
      "name": "bedrock",
      "type": "udp",
      "localIP": "127.0.0.1",
      "localPort": 19132,
      "remotePort": 19132
    }
  ]
}
```

> ⚠️ Cambia `localIP` si tu servidor está dentro de un contenedor Docker (`172.x.x.x`)

---

## 🧪 Pruebas

1. Inicia `frpc` en tu máquina:

   ```bash
   ./frpc --config frpc.json
   ```

2. Desde Minecraft Bedrock en otro dispositivo, conéctate a:

   ```
   IP: bedcrin.fly.dev
   Puerto: 19132
   ```

3. Verifica los logs de `frpc` para confirmar:

   ```
   [bedrock] start proxy success
   incoming a new work connection for udp proxy...
   ```

---

## 🧱 Requisitos

- Cuenta en [Fly.io](https://fly.io)
- Cuenta de GitHub (para desplegar automáticamente)
- Servidor local funcionando (Minecraft Bedrock u otro)
- Cliente `frpc` ejecutándose en la misma máquina o red que el servidor

---

## 📌 Notas

- Minecraft Bedrock es muy sensible a túneles UDP, por lo que **Fly.io puede no ser suficiente para algunos clientes**.
- Para máxima compatibilidad, se recomienda usar una VPS con IP pública dedicada (como Oracle o Hetzner) si necesitas estabilidad total.

---

## 🧙‍♂️ Autor

**Cristóbal Ruiz Lorite**  
👉 [https://crinlorite.com](https://crinlorite.com)

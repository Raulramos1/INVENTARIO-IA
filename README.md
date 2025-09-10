# INVENTARIO-IA — Home Assistant + Grocy (Docker + HACS)

Stack listo para levantar **Home Assistant** y **Grocy** con Docker Desktop y conectar ambos mediante la integración de Grocy (instalable vía HACS).  
Incluye configuración base de Home Assistant, variables de entorno y scripts para publicar este proyecto en GitHub.

> Fecha: 2025-09-10 · Zona horaria: Europe/Madrid

---

## 🚀 TL;DR (arranque rápido)

```bash
# 1) Clona o descomprime este repo
cd INVENTARIO-IA

# 2) Crea/ajusta variables
cp .env .env.local || true
# (Edita .env.local si quieres PUID/PGID/TZ distintos)

# 3) Sube los servicios
docker compose --env-file .env up -d

# 4) Abre las UIs
# Home Assistant: http://localhost:8123
# Grocy:         http://localhost:9283

# 5) En Grocy, crea un API key y añádelo a homeassistant/config/secrets.yaml
#    grocy_api_key: "TU_API_KEY"
```

---

## 📦 Estructura

```text
INVENTARIO-IA/
├─ docker/                        # (Reservado para futuros assets de despliegue)
├─ grocy/
│  └─ config/                     # Datos de Grocy (SQLite, config). Persistente
├─ homeassistant/
│  └─ config/
│     ├─ configuration.yaml       # Config base + integración Grocy por YAML
│     └─ secrets.yaml             # Claves (no subas tu API key al repo público)
├─ scripts/
│  ├─ powershell/
│  │  └─ publish.ps1              # Publicar/actualizar en GitHub
│  └─ bash/
│     └─ up.sh                    # Arranque en bash (opcional)
├─ docs/
│  └─ HAC S-instalacion.md        # Guía rápida de HACS y Grocy
├─ .env                           # TZ/PUID/PGID para Docker
├─ docker-compose.yml             # Servicios: Home Assistant + Grocy
├─ .gitignore
└─ LICENSE
```

---

## 🔧 Requisitos

- **Docker Desktop** (Windows/macOS) o Docker Engine (Linux)
- **Git**
- **PowerShell 7+** (si usarás el script `publish.ps1`)
- (Recomendado) **VS Code**

---

## 🧰 Variables (.env)

- `TZ`: zona horaria (por defecto `Europe/Madrid`)
- `PUID` y `PGID`: IDs de usuario/grupo para permisos en volúmenes.
  - Linux/macOS: ajusta a tu usuario (`id -u`, `id -g`).
  - Windows: normalmente puedes dejar `1000`.

---

## ▶️ Despliegue

1. Copia/ajusta `.env` si lo necesitas.
2. Levanta los servicios:
   ```bash
   docker compose --env-file .env up -d
   ```
3. Abre:
   - Home Assistant → <http://localhost:8123>
   - Grocy → <http://localhost:9283>

---

## 🔐 API key de Grocy

1. Entra a Grocy → menú de usuario (arriba dcha) → **API keys**.
2. Crea una nueva **API key**.
3. Edita `homeassistant/config/secrets.yaml` y añade:
   ```yaml
   grocy_api_key: "TU_API_KEY"
   ```
4. Reinicia Home Assistant desde **Ajustes → Sistema → Reiniciar**.

> La integración declarada en `configuration.yaml` leerá esta clave.

---

## 🧩 HACS e integración Grocy en Home Assistant

- Instala **HACS** (si aún no lo tienes) y, desde HACS, busca e instala **Grocy** (integración).
- Reinicia Home Assistant.
- *Alternativa por YAML ya incluida en este repo* (ver `configuration.yaml`).

> Tras instalar la integración Grocy con HACS, podrás explorar entidades y servicios
> relacionados con productos, tareas, listas de la compra, etc.

---

## ⚙️ Puertos

- Home Assistant: `8123`
- Grocy: `9283`

Si algún puerto está ocupado, cambia los mapeos en `docker-compose.yml`.

---

## 🧑‍💻 Flujo recomendado

1. Levantar `docker compose up -d`.
2. Obtener API key en Grocy y guardarla en `secrets.yaml`.
3. Instalar la integración **Grocy** desde HACS (o usar el YAML del repo).
4. Reiniciar Home Assistant y comprobar entidades.

---

## 🆘 Troubleshooting

- **Permisos en volúmenes**: ajusta `PUID/PGID` a tu usuario.
- **Puertos en uso**: cambia los mapeos `8123:8123` o `9283:9283`.
- **Conexión HA ↔ Grocy**: recuerda que HA contacta a Grocy por `http://grocy:9283` a través de la red de Docker.

---

## 📤 Publicar en tu GitHub

Usa el script PowerShell `scripts/powershell/publish.ps1` o ejecuta los comandos indicados en el propio script.

# Jewelry Website - Remedio Joyería

[![CI Status](https://github.com/infonetwokmedia-bot/Jewelry/actions/workflows/code-quality.yml/badge.svg)](https://github.com/infonetwokmedia-bot/Jewelry/actions/workflows/code-quality.yml)
[![WordPress](https://img.shields.io/badge/WordPress-6.9.1-blue.svg)](https://wordpress.org/)
[![WooCommerce](https://img.shields.io/badge/WooCommerce-10.5.0-purple.svg)](https://woocommerce.com/)
[![License](https://img.shields.io/badge/License-Private-red.svg)](LICENSE)

Sitio web bilingüe (Español/Inglés) para joyería en Miami, Florida.

## 🚀 Stack Tecnológico

- **WordPress** 6.x
- **WooCommerce** 10.5.0
- **Tema:** Kadence 1.4.3
- **Multiidioma:** Bogo 3.9.1
- **Infraestructura:** Docker + Traefik

## 📋 Requisitos

- Docker y Docker Compose
- Traefik configurado (red `traefik-public`)
- Acceso a `jewelry.local.dev` configurado en `/etc/hosts` o DNS local

## 🛠️ Instalación

1. Clonar el repositorio:

```bash
git clone https://github.com/infonetwokmedia-bot/Jewelry.git
cd Jewelry
```

2. Copiar y configurar variables de entorno:

```bash
cp .env.example .env
# Editar .env con tus credenciales
```

3. Iniciar los contenedores:

```bash
docker compose up -d
```

4. Acceder al sitio:

- Frontend: https://jewelry.local.dev
- Admin: https://jewelry.local.dev/wp-admin
- phpMyAdmin: https://phpmyadmin.jewelry.local.dev

## 🌍 Idiomas

El sitio soporta dos idiomas:

- **Español (es_ES)** - Idioma principal
- **English (en_US)** - Idioma secundario

La gestión de traducciones se realiza con Bogo.

## � Descargar Archivos de Configuración IA

Este repositorio incluye archivos de configuración para herramientas de IA en la carpeta `.ai-tools/`:

- **Claude (Anthropic):** Configuración de proyecto y custom instructions
- **ChatGPT (OpenAI):** Custom GPT setup y prompts
- **GitHub Copilot:** Custom agents y workflows
- **Codeium:** Configuración avanzada y snippets

### Cómo Descargar

**Opción 1: Clone completo**

```bash
git clone https://github.com/infonetwokmedia-bot/Jewelry.git
cd Jewelry/.ai-tools/
```

**Opción 2: Solo la carpeta .ai-tools/**

```bash
# Requiere GitHub CLI (gh)
gh repo clone infonetwokmedia-bot/Jewelry -- --depth 1 --filter=blob:none --sparse
cd Jewelry
git sparse-checkout set .ai-tools
```

**Opción 3: Descarga manual**

1. Navega a [`.ai-tools/`](https://github.com/infonetwokmedia-bot/Jewelry/tree/main/.ai-tools) en GitHub
2. Descarga los archivos que necesites

**Nota:** Personaliza los archivos con tu propia configuración antes de usarlos.

## �📁 Estructura del Proyecto

```
.
├── docker-compose.yml          # Configuración de contenedores
├── .env                        # Variables de entorno
├── data/
│   ├── mysql/                  # Base de datos MySQL
│   └── wordpress/              # Archivos de WordPress
│       └── wp-content/
│           ├── themes/
│           │   └── kadence/
│           │       └── functions-custom.php  # Personalizaciones
│           └── plugins/
└── PROYECTO-ESTADO.md          # Estado actual del desarrollo
```

## 🔧 Configuración

### Páginas Principales

- 12 páginas en inglés
- 12 páginas en español
- Todas vinculadas con Bogo

### Productos

- 5 productos base en cada idioma
- Organizados en 4 categorías principales

### Menús

- Menú principal EN (primary_navigation_en)
- Menú principal ES (primary_navigation_es)
- Cambio automático según idioma del usuario

## 📝 Desarrollo

### 📚 Documentación Completa

- **[Guía de Desarrollo](docs/DEVELOPMENT.md)** - Setup, workflow, convenciones de código, testing, debugging
- **[Guía de Despliegue](docs/DEPLOYMENT.md)** - Proceso completo de deploy a producción
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Problemas comunes y soluciones
- **[Cómo Contribuir](CONTRIBUTING.md)** - Proceso de contribución, code review, PR guidelines
- **[Política de Seguridad](SECURITY.md)** - Reporte de vulnerabilidades, prácticas de seguridad
- **[Estado del Proyecto](PROYECTO-ESTADO.md)** - Progress tracking, roadmap, pendientes

### 🛠️ Scripts de Mantenimiento

El proyecto incluye scripts automatizados en [`scripts/`](scripts/):

```bash
# Setup completo del entorno
./scripts/setup-dev.sh

# Backup de base de datos
./scripts/backup-database.sh

# Restaurar backup
./scripts/restore-database.sh

# Limpiar cache (WP + WooCommerce)
./scripts/clear-cache.sh

# Test de conexiones y salud de servicios
./scripts/test-connections.sh
```

Ver [`scripts/README.md`](scripts/README.md) para más información.

### 🧪 Testing

```bash
# Tests de conexión y servicios
./scripts/test-connections.sh

# Tests PHP (cuando estén implementados)
docker exec jewelry_wordpress vendor/bin/phpunit

# Ver logs en tiempo real
docker compose logs -f wordpress
```

### Comandos Útiles WP-CLI

```bash
# Acceder a WP-CLI
docker exec jewelry_wordpress wp --allow-root [comando]

# Listar plugins
docker exec jewelry_wordpress wp plugin list --allow-root

# Listar productos
docker exec jewelry_wordpress wp post list --post_type=product --allow-root

# Regenerar permalinks
docker exec jewelry_wordpress wp rewrite flush --allow-root

# Limpiar cache
docker exec jewelry_wordpress wp cache flush --allow-root

# Verificar vinculación Bogo
docker exec jewelry_wordpress wp post meta get <ID> _bogo_translations --allow-root
```

Ver [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) para workflow completo y convenciones.

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Por favor lee nuestra [**Guía de Contribución**](CONTRIBUTING.md) para conocer:

- Proceso de desarrollo (branches, commits)
- Estándares de código (WordPress, prefijo `jewelry_`, Yoda conditions)
- **Regla crítica: Contenido bilingüe** (ES + EN con Bogo linking)
- Testing requerido
- Code review guidelines

### Workflow Rápido

```bash
# 1. Fork y clone
git clone https://github.com/tu-usuario/jewelry.git

# 2. Crear branch
git checkout -b feature/mi-feature

# 3. Hacer cambios (siguiendo convenciones)

# 4. Commit (Conventional Commits)
git commit -m "feat(products): añadir filtro por precio"

# 5. Push y crear PR
git push origin feature/mi-feature
```

Al abrir un **Pull Request**, encontrarás un [**template automático**](.github/pull_request_template.md) con checklist completo para asegurar calidad.

### Reportar Bugs o Sugerencias

- **Bugs:** Abre un [GitHub Issue](https://github.com/infonetwokmedia-bot/Jewelry/issues/new) con detalles
- **Vulnerabilidades de seguridad:** Lee [SECURITY.md](SECURITY.md) primero (NO crear issue público)

## ⚙️ CI/CD y Automatización

El proyecto incluye workflows automatizados de GitHub Actions:

- **[Code Quality](.github/workflows/code-quality.yml)** - Ejecuta en cada PR/push:
  - ✅ Security audit (credenciales, archivos sensibles)
  - ✅ PHP syntax check
  - ✅ Markdown linting
  - ✅ Verificación de estructura del repo
- **[Weekly Backup Reminder](.github/workflows/backup-weekly.yml)** - Cron cada domingo:
  - 📋 Crea issue de GitHub con checklist de backup
  - 📝 Incluye comandos útiles para ejecutar

Ver todos los workflows en [`.github/workflows/`](.github/workflows/).

## 📄 Licencia

Proyecto privado - Remedio Joyería © 2026

---

**Mantenido por:** [Equipo de Desarrollo Jewelry](https://github.com/infonetwokmedia-bot)  
**Última actualización:** 10 de febrero de 2026

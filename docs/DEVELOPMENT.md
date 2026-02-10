# Guía de Desarrollo - Jewelry Project

Guía completa para desarrollar en el proyecto Jewelry (WordPress + WooCommerce bilingüe).

## 📋 Tabla de Contenidos

- [Requisitos](#requisitos)
- [Setup Inicial](#setup-inicial)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Workflow de Desarrollo](#workflow-de-desarrollo)
- [Convenciones de Código](#convenciones-de-código)
- [Testing](#testing)
- [Debugging](#debugging)
- [Herramientas IA](#herramientas-ia)

---

## 🔧 Requisitos

### Software Requerido

- **Docker** 24.0+ y **Docker Compose** 2.20+
- **Git** 2.40+
- **Node.js** 18+ (opcional, para tests E2E)
- **VS Code** (recomendado) con extensiones:
  - GitHub Copilot
  - PHP Intelephense
  - Docker
  - GitLens

### Conocimientos Recomendados

- PHP 8.1+
- WordPress 6.x
- WooCommerce 10.x
- Plugin Bogo para multiidioma
- Docker básico
- Git workflows

---

## 🚀 Setup Inicial

### 1. Clonar Repositorio

```bash
git clone https://github.com/infonetwokmedia-bot/Jewelry.git
cd Jewelry
```

### 2. Configurar Entorno

```bash
# Ejecutar script de setup automático
chmod +x scripts/*.sh
./scripts/setup-dev.sh
```

O manualmente:

```bash
# Copiar .env
cp .env.example .env

# Editar .env y configurar contraseñas
nano .env

# Iniciar contenedores
docker compose up -d

# Esperar que MySQL esté listo (30 segundos aprox)
sleep 30

# Verificar conectividad
./scripts/test-connections.sh
```

### 3. Acceder al Sitio

- **Frontend:** https://jewelry.local.dev
- **Admin:** https://jewelry.local.dev/wp-admin
- **phpMyAdmin:** https://phpmyadmin.jewelry.local.dev

**Credenciales por defecto** (cambiar en producción):

- Usuario: `admin`
- Password: Ver `.env` → `WORDPRESS_ADMIN_PASSWORD`

---

## 📁 Estructura del Proyecto

```
jewelry/
├── .github/
│   ├── agents/                    # Custom agents de Copilot (6)
│   ├── workflows/                 # CI/CD workflows
│   ├── copilot-instructions.md    # Instrucciones globales
│   └── COPILOT-SKILLS.md         # Skills documentados
│
├── .ai-tools/                     # Recursos para IAs
│   ├── claude/                    # Setup de Claude Pro
│   ├── chatgpt/                   # Prompts de ChatGPT
│   ├── codeium/                   # Guía de Codeium
│   └── workflows/                 # Workflows optimizados
│
├── data/
│   ├── mysql/                     # Base de datos (gitignore)
│   └── wordpress/
│       └── wp-content/
│           ├── themes/kadence/
│           │   └── functions-custom.php    # ⚠️ Modificar aquí
│           ├── plugins/
│           │   └── jewelry-custom/         # Plugin custom (crear)
│           └── mu-plugins/                 # Must-use plugins
│
├── scripts/                       # Utilidades de mantenimiento
│   ├── backup-database.sh
│   ├── restore-database.sh
│   ├── setup-dev.sh
│   ├── clear-cache.sh
│   └── test-connections.sh
│
├── docs/                          # Documentación técnica
│   ├── DEVELOPMENT.md             # Esta guía
│   ├── DEPLOYMENT.md
│   └── TROUBLESHOOTING.md
│
├── tests/                         # Suite de tests
│   ├── php/                       # PHPUnit tests
│   └── e2e/                       # Tests end-to-end
│
├── .editorconfig                  # Configuración de editor
├── .gitignore                     # Archivos ignorados
├── .env.example                   # Template de variables
├── docker-compose.yml             # Definición de servicios
├── README.md                      # Vista general
└── PROYECTO-ESTADO.md            # Estado e hitos
```

### ⚠️ Archivos a MODIFICAR

- `data/wordpress/wp-content/themes/kadence/functions-custom.php` - Funciones custom del tema
- `data/wordpress/wp-content/plugins/jewelry-custom/` - Plugin custom (si se crea)
- `data/wordpress/wp-content/mu-plugins/` - Must-use plugins

### ❌ Archivos a NO MODIFICAR

- Core de WordPress: `wp-admin/`, `wp-includes/`
- Core de plugins instalados
- `data/mysql/` - Base de datos

---

## 🔄 Workflow de Desarrollo

### Estrategia de Branches

- `main` - Producción estable (protegido)
- `develop` - Desarrollo activo
- `feature/*` - Nuevas features
- `fix/*` - Bug fixes
- `hotfix/*` - Fixes urgentes para producción

### Crear Nueva Feature

```bash
# Actualizar develop
git checkout develop
git pull origin develop

# Crear feature branch
git checkout -b feature/nombre-descriptivo

# Hacer cambios...

# Commit con conventional commits
git add .
git commit -m "feat(products): añadir importación masiva bilingüe"

# Push
git push origin feature/nombre-descriptivo

# Crear PR en GitHub: feature/nombre-descriptivo → develop
```

### Conventional Commits

Formato:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**

- `feat` - Nueva feature
- `fix` - Bug fix
- `docs` - Solo documentación
- `style` - Formato (no código)
- `refactor` - Refactorización
- `test` - Tests
- `chore` - Mantenimiento
- `security` - Seguridad

**Ejemplos:**

```
feat(products): añadir script de creación bilingüe
fix(bogo): corregir vinculación de categorías
docs(ai-tools): actualizar guía de Claude
security: eliminar wp-config backups
```

---

## 📝 Convenciones de Código

### PHP (WordPress Coding Standards)

```php
/**
 * Crear producto bilingüe con vinculación Bogo.
 *
 * @param array $data_es Datos en español.
 * @param array $data_en Datos en inglés.
 * @return array IDs de productos creados.
 */
function jewelry_create_bilingual_product( $data_es, $data_en ) {
    // Prefijo jewelry_ SIEMPRE
    // 4 espacios de indentación
    // Yoda conditions
    if ( 'value' === $variable ) {
        return true;
    }

    // Sanitizar entradas
    $name_es = sanitize_text_field( $data_es['name'] );

    // Escapar salidas
    echo esc_html( $user_input );

    return array(
        'es' => $product_id_es,
        'en' => $product_id_en,
    );
}
```

### JavaScript

```javascript
// 2 espacios de indentación
// Usar const/let, NO var
const jewelryApp = {
  init() {
    const locale = document.documentElement.lang;
    if (locale === "es-ES") {
      this.loadSpanishContent();
    }
  },
};
```

### REGLA FUNDAMENTAL: Contenido Bilingüe

**⚠️ CRÍTICO: SIEMPRE crear contenido en AMBOS idiomas**

```php
// ✅ CORRECTO
$ids = jewelry_create_bilingual_product( $data_es, $data_en );

// ❌ INCORRECTO - Solo un idioma
$id = wp_insert_post( $data_es );
```

---

## 🧪 Testing

### Ejecutar Tests

```bash
# PHP Unit Tests
docker exec jewelry_wordpress vendor/bin/phpunit tests/php/

# E2E Tests
npm run test:e2e

# Verification completa
./scripts/test-connections.sh
```

### Crear Nuevo Test

Ver [../tests/README.md](../tests/README.md) para templates.

---

## 🐛 Debugging

### Ver Logs

```bash
# WordPress logs
docker logs jewelry_wordpress -f

# MySQL logs
docker logs jewelry_mysql -f

# Todos los logs
docker compose logs -f

# PHP errors
tail -f data/wordpress/wp-content/debug.log
```

### Habilitar WP_DEBUG

Editar `data/wordpress/wp-config.php`:

```php
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', false );
@ini_set( 'display_errors', 0 );
```

### Comandos WP-CLI

```bash
# Estructura base
docker exec jewelry_wordpress wp --allow-root [comando]

# Ejemplos
docker exec jewelry_wordpress wp post list --post_type=product --allow-root
docker exec jewelry_wordpress wp plugin list --allow-root
docker exec jewelry_wordpress wp cache flush --allow-root
```

### Debugging en VS Code

Configurar Xdebug (opcional):

```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Listen for Xdebug",
      "type": "php",
      "request": "launch",
      "port": 9003,
      "pathMappings": {
        "/var/www/html": "${workspaceFolder}/data/wordpress"
      }
    }
  ]
}
```

---

## 🤖 Herramientas IA

El proyecto está optimizado para uso con múltiples IAs:

### GitHub Copilot

**Custom Agents disponibles:**

- `@product-creator` - Crear productos WooCommerce
- `@page-builder` - Crear páginas bilingües
- `@bogo-expert` - Vincular contenido multiidioma
- `@woocommerce-expert` - Configurar WooCommerce
- `@security-reviewer` - Revisar seguridad
- `@database-manager` - Gestión de DB

**Uso:**

```
@product-creator Crea cadena cubana 10k de 6mm por $499
```

### Claude Pro

Archivos listos en `.ai-tools/claude/project-files/`:

- Subir a claude.ai como Project Knowledge
- Ver guía: `.ai-tools/claude/SETUP-GUIDE.md`

### ChatGPT Plus

50+ prompts disponibles en `.ai-tools/chatgpt/prompts-library.md`

**Crear Custom GPT:**

- Ver: `.ai-tools/chatgpt/SETUP-GUIDE.md`

### Codeium (Gratuito)

Autocompletado complementario a Copilot.

- Ver: `.ai-tools/codeium/README.md`

---

## 📚 Recursos Adicionales

- [PROYECTO-ESTADO.md](../PROYECTO-ESTADO.md) - Estado actual del proyecto
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Problemas comunes
- [DEPLOYMENT.md](./DEPLOYMENT.md) - Despliegue a producción
- [WordPress Codex](https://codex.wordpress.org/)
- [WooCommerce Docs](https://woocommerce.github.io/code-reference/)
- [Bogo Plugin](https://wordpress.org/plugins/bogo/)

---

**Última actualización:** 10 de febrero de 2026  
**Mantenedor:** Equipo de Desarrollo Jewelry

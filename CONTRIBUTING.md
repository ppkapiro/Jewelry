# Guía de Contribución - Jewelry Project

¡Gracias por tu interés en contribuir al proyecto Jewelry! Esta guía te ayudará a entender el proceso de contribución.

## 📋 Tabla de Contenidos

- [Cómo Contribuir](#cómo-contribuir)
- [Proceso de Desarrollo](#proceso-de-desarrollo)
- [Estándares de Código](#estándares-de-código)
- [Conventional Commits](#conventional-commits)
- [Testing](#testing)
- [Code Review](#code-review)

---

## 🤝 Cómo Contribuir

### 1. Fork y Clone

```bash
# Fork el repositorio en GitHub, luego:
git clone https://github.com/tu-usuario/jewelry.git
cd jewelry

# Añadir upstream
git remote add upstream https://github.com/usuario-original/jewelry.git
```

### 2. Configurar Entorno Local

```bash
# Copiar .env de ejemplo
cp .env.example .env

# Editar credenciales
nano .env

# Setup automático
./scripts/setup-dev.sh

# O manual (ver docs/DEVELOPMENT.md)
```

### 3. Crear Branch

**Convención de nombres:**

```bash
# Features
git checkout -b feature/descripcion-corta

# Bug fixes
git checkout -b fix/descripcion-del-bug

# Hotfixes urgentes
git checkout -b hotfix/descripcion-urgente

# Documentación
git checkout -b docs/actualizar-readme

# Refactoring
git checkout -b refactor/optimizar-queries
```

### 4. Hacer Cambios

**⚠️ REGLA CRÍTICA: Contenido Bilingüe**

Si creas/editas contenido WordPress (páginas, productos, posts):

1. **SIEMPRE crear en AMBOS idiomas:** Español (es_ES) + Inglés (en_US)
2. **SIEMPRE vincular con Bogo:** Ver ejemplos en [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md#crear-producto-bilingüe)
3. **Verificar vinculación:** Antes de commit, confirmar que ambos posts están linkeados

**Prefijo de funciones:**

- **SIEMPRE usar `jewelry_`** como prefijo en funciones custom PHP
- Ejemplo: `jewelry_get_featured_products()`, NO `get_featured_products()`

**Archivo de modificaciones del tema:**

- Editar solo: `data/wordpress/wp-content/themes/kadence/functions-custom.php`
- **NO editar** archivos core del tema Kadence

### 5. Commits

Ver sección [Conventional Commits](#conventional-commits).

### 6. Push y Pull Request

```bash
# Actualizar desde upstream primero
git fetch upstream
git rebase upstream/develop

# Push a tu fork
git push origin feature/tu-feature

# Crear Pull Request en GitHub
# Usar el template automático (.github/pull_request_template.md)
```

---

## 🔄 Proceso de Desarrollo

### Workflow de Branches

```
main (protegido)
  ↑
  ├─ hotfix/* (merge directo a main + develop)
  ↑
develop (branch activo)
  ↑
  ├─ feature/* (merge a develop)
  ├─ fix/*
  └─ docs/*
```

**Reglas:**

- **`main`:** Solo releases estables. Requiere PR review + CI passing.
- **`develop`:** Trabajo activo. Merge de features aquí primero.
- **`feature/*`:** Una feature por branch. Merge a `develop`.
- **`hotfix/*`:** Fixes urgentes. Merge a `main` + `develop`.

### Sincronización Frecuente

```bash
# Al menos una vez al día
git checkout develop
git pull upstream develop
git checkout tu-branch
git rebase develop
```

---

## 📏 Estándares de Código

### PHP

**Seguir [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/):**

```php
<?php
/**
 * Breve descripción de la función.
 *
 * Descripción más larga si es necesario.
 *
 * @param string $param1 Descripción del parámetro.
 * @param int    $param2 Otro parámetro.
 * @return bool Retorna true si éxito.
 */
function jewelry_mi_funcion( $param1, $param2 ) {
    // Yoda conditions
    if ( 'valor' === $param1 ) {
        return true;
    }

    // 4 espacios de indentación (no tabs)
    return false;
}
```

**Convenciones clave:**

- ✅ Prefijo `jewelry_` en funciones custom
- ✅ 4 espacios para indentación (no tabs)
- ✅ Yoda conditions: `'value' === $variable`
- ✅ Comillas simples por defecto, dobles si hay interpolación
- ✅ Espacios alrededor de operadores: `$a + $b`
- ✅ Abrir llaves en la misma línea

**Seguridad obligatoria:**

```php
// SIEMPRE sanitizar input
$email = sanitize_email( $_POST['email'] );
$text = sanitize_text_field( $_POST['text'] );

// SIEMPRE escapar output
echo esc_html( $user_input );
echo esc_attr( $attr_value );
echo esc_url( $url );

// SIEMPRE verificar nonce en formularios
if ( ! isset( $_POST['jewelry_nonce'] ) ||
     ! wp_verify_nonce( $_POST['jewelry_nonce'], 'jewelry_action' ) ) {
    wp_die( 'Unauthorized' );
}
```

### JavaScript

```javascript
// Usar const/let, NO var
const myVar = "value";
let counter = 0;

// 2 espacios de indentación
function jewelryApp() {
  if (condition) {
    doSomething();
  }
}

// Template literals para interpolación
const message = `Hello, ${name}!`;

// Arrow functions
const add = (a, b) => a + b;
```

### CSS

```css
/* Usar kebab-case para clases */
.jewelry-product-card {
  display: flex;
  flex-direction: column;

  /* 2 espacios de indentación */
  padding: 1rem;
  margin: 0.5rem;
}

/* Prefijo jewelry- para evitar conflictos */
.jewelry-cta-button {
}
```

---

## 📝 Conventional Commits

**Formato obligatorio:**

```
<type>(<scope>): <subject>

[body opcional]

[footer opcional]
```

### Types

| Type       | Uso                          |
| ---------- | ---------------------------- |
| `feat`     | Nueva funcionalidad          |
| `fix`      | Corrección de bug            |
| `docs`     | Cambios en documentación     |
| `style`    | Formato (no afecta código)   |
| `refactor` | Refactorización              |
| `test`     | Añadir/modificar tests       |
| `chore`    | Mantenimiento (deps, config) |
| `security` | Fixes de seguridad           |

### Ejemplos

```bash
# Feature
git commit -m "feat(products): añadir filtro por precio en shop"

# Bug fix
git commit -m "fix(bogo): corregir vinculación de productos bilingües"

# Documentación
git commit -m "docs(readme): actualizar sección de instalación"

# Refactoring
git commit -m "refactor(functions): optimizar jewelry_get_products()"

# Testing
git commit -m "test(woocommerce): añadir tests para checkout"

# Chore
git commit -m "chore(deps): actualizar WooCommerce a 10.5.1"

# Security
git commit -m "security(auth): sanitizar input en formulario de contacto"
```

**Body y footer (opcional):**

```bash
git commit -m "fix(checkout): resolver error en validación de cupones

El campo de cupón no validaba correctamente cupones con guiones.
Ahora se sanitiza el input antes de verificar en BD.

Fixes #123
Reviewed-by: Juan Pérez"
```

---

## 🧪 Testing

**Antes de hacer PR:**

### 1. Tests Automáticos

```bash
# Test de conexiones
./scripts/test-connections.sh

# Tests PHP (cuando estén implementados)
docker exec jewelry_wordpress vendor/bin/phpunit

# Lint PHP
find data/wordpress/wp-content/themes/kadence/functions-custom.php \
    -name "*.php" -exec php -l {} \;
```

### 2. Tests Manuales

**Checklist mínimo:**

- [ ] Homepage carga sin errores
- [ ] Cambio de idioma funciona (ES ↔ EN)
- [ ] Si cambios en productos: Shop muestra correctamente
- [ ] Si cambios en checkout: Proceso completo funciona
- [ ] Si cambios en Bogo: Vinculación correcta de traducciones
- [ ] No hay errores en consola del navegador
- [ ] No hay errores en logs Docker

```bash
# Ver logs en tiempo real
docker compose logs -f wordpress | grep -i error
```

### 3. Verificar Bilingüismo

**Si creaste contenido nuevo:**

```bash
# Verificar que ambos posts existen
docker exec jewelry_wordpress wp post list \
    --post_type=product \
    --post_title="Nombre del Producto" \
    --allow-root

# Verificar vinculación Bogo
docker exec jewelry_wordpress wp post meta get <ID> _bogo_translations --allow-root
docker exec jewelry_wordpress wp post meta get <ID> _locale --allow-root
```

---

## 👀 Code Review

### Para Reviewers

**Qué verificar:**

1. **Conventional Commits:** Formato correcto
2. **Prefijo jewelry\_:** En funciones custom PHP
3. **Bilingüismo:** Si hay contenido, está en ES + EN
4. **Bogo linking:** Traduciones vinculadas correctamente
5. **Seguridad:** Sanitización y escape
6. **WordPress Standards:** Indentación, Yoda conditions, etc.
7. **Tests:** CI passing, tests manuales realizados
8. **Documentación:** README/docs actualizados si aplica

### Para Contributors

**Checklist antes de solicitar review:**

```markdown
## Checklist PR

- [ ] Conventional commits usados
- [ ] Funciones custom con prefijo `jewelry_`
- [ ] Contenido creado en ES + EN (si aplica)
- [ ] Bogo linking verificado (si aplica)
- [ ] Input sanitizado, output escapado
- [ ] WordPress Coding Standards seguidos
- [ ] Tests ejecutados (`./scripts/test-connections.sh`)
- [ ] CI checks passing (GitHub Actions)
- [ ] Documentación actualizada (si aplica)
- [ ] Screenshots incluidos (si hay cambios visuales)
```

### Responder a Feedback

```bash
# Hacer cambios solicitados
git add .
git commit -m "refactor: aplicar feedback de code review"
git push origin feature/tu-branch

# El PR se actualiza automáticamente
```

---

## 🐛 Reportar Bugs

**Usar GitHub Issues con el template:**

1. **Título claro:** `[Bug] Checkout no acepta tarjetas VISA`
2. **Descripción:** Qué esperabas vs. qué pasó
3. **Pasos para reproducir:** Lista numerada
4. **Entorno:** Browser, versión WP, plugins activos
5. **Screenshots:** Si aplica
6. **Logs:** Errores relevantes

---

## ❓ Preguntas

- **Chat del equipo:** Slack/Discord (si existe)
- **GitHub Discussions:** Para preguntas generales
- **Issues:** Solo para reportar bugs/features

---

## 📚 Referencias

- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) - Guía completa de desarrollo
- [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) - Proceso de despliegue
- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - Problemas comunes
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

**¡Gracias por contribuir!** 🎉

_Última actualización: 10 de febrero de 2026_

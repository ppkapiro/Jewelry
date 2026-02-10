# Codeium - Guía de Uso para Proyecto Jewelry

## 🎯 Casos de Uso Principales

Codeium es ideal para:
- ⚡ **Autocompletado de código en tiempo real** (similar a Copilot)
- 🔍 **Búsqueda semántica en codebase** (encuentra código por descripción)
- 💬 **Chat inline con contexto del proyecto**
- 🐛 **Refactoring rápido** (renombrar, extraer funciones)
- 📝 **Documentación automática** (PHPDoc, comentarios)

## 🆓 Ventajas de Codeium

- **100% Gratuito** (sin límites)
- **Privacidad:** Código no se usa para entrenamiento
- **Multi-lenguaje:** PHP, JavaScript, CSS, SQL, etc.
- **Integración VS Code:** Extensión oficial
- **Búsqueda Codebase:** Encuentra código rápidamente

## 🚀 Setup

### 1. Instalar Extensión

```bash
code --install-extension Codeium.codeium
```

O desde VS Code:
1. Ir a Extensions (Ctrl+Shift+X)
2. Buscar "Codeium"
3. Click en "Install"

### 2. Autenticar

1. Abrir Command Palette (Ctrl+Shift+P)
2. Ejecutar: `Codeium: Sign In`
3. Crear cuenta gratuita en https://codeium.com
4. Autorizar en navegador
5. Volver a VS Code (auto-configurado)

### 3. Configurar Keybindings

Añadir a `.vscode/keybindings.json`:
```json
[
  {
    "key": "ctrl+alt+space",
    "command": "codeium.acceptCompletion",
    "when": "editorTextFocus"
  },
  {
    "key": "ctrl+alt+[",
    "command": "codeium.cycleAutocompleteBackward",
    "when": "editorTextFocus"
  },
  {
    "key": "ctrl+alt+]",
    "command": "codeium.cycleAutocompleteForward",
    "when": "editorTextFocus"
  }
]
```

## 💡 Uso Efectivo

### Autocompletado Inteligente

**Escribir comentarios descriptivos:**
```php
// Función para crear producto WooCommerce bilingüe con vinculación Bogo
// Parámetros: nombre_es, nombre_en, precio, sku
function jewelry_create_bilingual_product( $data_es, $data_en ) {
    // Codeium completará automáticamente basándose en:
    // - Contexto del archivo
    // - Skills de .claude/skills/SKILLS.md
    // - Funciones similares en el proyecto
```

### Chat Inline

**Abrir chat:** `Ctrl+I` (o Command Palette > "Codeium: Open Chat")

**Prompts efectivos:**
```
- "Refactoriza esta función para seguir WordPress Coding Standards"
- "Añade PHPDoc a esta función"
- "Convierte este código para usar WP_Query en lugar de SQL directo"
- "Añade sanitización de inputs a este formulario"
- "Genera versión en inglés de esta función (actualmente en español)"
```

### Búsqueda Codebase

**Abrir búsqueda:** Command Palette > "Codeium: Search Codebase"

**Ejemplos de búsqueda:**
```
- "función que crea productos con Bogo"
- "código de vinculación multiidioma"
- "sanitización de formularios WordPress"
- "WP-CLI scripts de productos"
- "gestión de categorías bilingües"
```

## 🔧 Workflows con Codeium

### Workflow 1: Desarrollo Rápido de Funciones

1. **Escribir signature de función con comentario:**
```php
/**
 * Obtiene productos destacados del catálogo bilingüe.
 * Filtra por idioma usando Bogo.
 */
function jewelry_get_featured_products_by_locale( $locale, $limit = 10 ) {
    // Codeium sugerirá implementation completa
```

2. **Revisar sugerencias:** `Ctrl+Alt+]` para siguiente sugerencia

3. **Aceptar:** `Ctrl+Alt+Space`

### Workflow 2: Documentación Automática

1. **Posicionar cursor sobre función:**
```php
function jewelry_create_bilingual_page( $title_es, $title_en, $content_es, $content_en ) {
```

2. **Escribir `/**` y presionar Enter**

3. **Codeium generará PHPDoc automáticamente:**
```php
/**
 * Crea una página bilingüe con vinculación Bogo.
 *
 * @param string $title_es Título en español.
 * @param string $title_en Título en inglés.
 * @param string $content_es Contenido en español.
 * @param string $content_en Contenido en inglés.
 * @return array IDs de las páginas creadas.
 */
```

### Workflow 3: Refactoring con Chat

1. **Seleccionar código a refactorizar**

2. **Abrir chat:** `Ctrl+I`

3. **Prompt:**
```
Refactoriza este código para:
- Seguir WordPress Coding Standards
- Usar prefijo jewelry_
- Sanitizar todos los inputs
- Añadir validación de nonce
- Retornar WP_Error en caso de fallo
```

4. **Aplicar cambios sugeridos**

### Workflow 4: Traducción de Código

**Problema:** Tengo función en español, necesito versión en inglés

```php
// Seleccionar esta función:
function jewelry_obtener_productos_categoria( $categoria_slug, $idioma = 'es_ES' ) {
    // código aquí
}
```

**Chat de Codeium:**
```
Crea versión en inglés de esta función:
- Mantener lógica exacta
- Traducir nombres de variables y comentarios
- Actualizar locale a 'en_US' por defecto
```

## 🎨 Configuración Avanzada

### Proyectos Múltiples

Codeium aprende de todo el workspace. Si tienes múltiples proyectos:

```json
// .vscode/settings.json
{
  "codeium.enableCodeLens": true,
  "codeium.enableSearch": true,
  "codeium.workspaceRootPaths": [
    "/srv/stacks/jewelry"
  ]
}
```

### Ignorar Archivos

```json
// .vscode/settings.json
{
  "codeium.ignorePaths": [
    "**/node_modules/**",
    "**/vendor/**",
    "**/data/mysql/**",
    "**/data/wordpress/wp-admin/**",
    "**/data/wordpress/wp-includes/**"
  ]
}
```

### Multiidioma

Codeium detecta automáticamente el idioma del código. Para proyecto bilingüe:

```json
// .vscode/settings.json
{
  "codeium.languages": {
    "php": true,
    "javascript": true,
    "css": true,
    "sql": true,
    "markdown": true,
    "shellscript": true
  }
}
```

## 🆚 Codeium vs Copilot

### Cuándo usar Codeium
- ✅ Autocompletado rápido para código común
- ✅ Búsqueda en codebase por descripción
- ✅ Refactoring simple
- ✅ 100% gratuito, ilimitado

### Cuándo usar Copilot
- ✅ Patrones WordPress específicos (con custom agents)
- ✅ Scripts WP-CLI completos
- ✅ Features complejas del proyecto
- ✅ Integración con GitHub Actions

**Recomendación:** Usar AMBOS simultáneamente
- Codeium para autocompletado general
- Copilot para tareas específicas del proyecto

## 💰 Costos

**100% GRATUITO** 🎉
- Sin límites de completions
- Sin límites de chat
- Sin límites de búsqueda
- Sin tarjeta de crédito requerida

## 📋 Checklist de Setup

- [ ] Extensión Codeium instalada
- [ ] Autenticado con cuenta gratuita
- [ ] Keybindings configurados
- [ ] Ignorar archivos configurado
- [ ] Probado autocompletado con comentario
- [ ] Probado chat inline (Ctrl+I)
- [ ] Probado búsqueda codebase
- [ ] Verificar que no interfiere con Copilot

## 🚨 Troubleshooting

### Codeium no sugiere nada

**Solución:**
```bash
# Recargar VS Code
Ctrl+Shift+P > "Developer: Reload Window"

# Verificar autenticación
Ctrl+Shift+P > "Codeium: Sign In"
```

### Conflicto con Copilot

Ambos pueden coexistir. Configurar prioridad en `settings.json`:
```json
{
  "editor.inlineSuggest.enabled": true,
  "github.copilot.enable": {
    "*": true
  },
  "codeium.enableCodeLens": true
}
```

### Sugerencias irrelevantes

Mejorar contexto con comentarios más descriptivos:
```php
// ❌ Mal: función de productos
// ✅ Bien: función que obtiene productos WooCommerce filtrados por idioma Bogo
```

## 🔗 Recursos

- [Codeium Website](https://codeium.com)
- [Codeium Docs](https://codeium.com/docs)
- [VS Code Extension](https://marketplace.visualstudio.com/items?itemName=Codeium.codeium)

---

**Tip:** Codeium es excelente complemento gratuito a Copilot. Úsalo para autocompletado rápido mientras Copilot maneja lógica compleja del proyecto.

# 🤖 Herramientas IA - Proyecto Jewelry

## 📋 Overview

Este directorio contiene guías, scripts y configuraciones para optimizar el desarrollo del proyecto Jewelry usando múltiples herramientas de IA.

## 🎯 Filosofía Multi-IA

En lugar de depender de una sola herramienta, usamos un **ecosistema de IAs especializadas**:

- **GitHub Copilot** → Código WordPress/WooCommerce específico del proyecto
- **Claude** → Análisis profundo, refactoring, documentación técnica
- **Codeium** → Autocompletado general gratuito, búsqueda codebase
- **ChatGPT-4** → Contenido marketing, SEO, copy bilingüe

## 📁 Estructura

```
.ai-tools/
├── README.md                      # Este archivo
├── shared-context.md              # Contexto del proyecto para todas las IAs
├── test-ai-tools.sh              # Script para verificar setup
│
├── claude/
│   └── README.md                  # Guía de uso de Claude
│
├── codeium/
│   └── README.md                  # Guía de uso de Codeium
│
├── chatgpt/
│   ├── README.md                  # Guía de uso de ChatGPT
│   └── prompts-library.md         # Biblioteca de prompts efectivos
│
└── workflows/
    ├── product-creation.md        # Workflow completo de creación de productos
    ├── bulk-import.md             # Importación masiva de productos
    ├── email-customization.md     # Personalización de emails WooCommerce
    └── troubleshooting-bogo.md    # Resolución de problemas Bogo
```

## 🚀 Quick Start

### 1. Verificar Setup

```bash
# Ejecutar script de test
./.ai-tools/test-ai-tools.sh
```

Este script verifica:
- ✅ Estructura del proyecto
- ✅ Contenedores Docker corriendo
- ✅ WordPress y plugins activos
- ✅ Configuración multiidioma (Bogo)
- ✅ Extensiones VS Code (opcional)

### 2. Configurar VS Code

```bash
# Copiar configuración de settings
cp .vscode/settings-ai-tools.json .vscode/settings.json

# O merge con tu settings.json existente
```

### 3. Instalar Extensiones Recomendadas

**Esenciales:**
```bash
code --install-extension github.copilot
code --install-extension codeium.codeium
code --install-extension bmewburn.vscode-intelephense-client
```

**Opcionales:**
```bash
code --install-extension continue.continue  # Para Claude API
code --install-extension ms-azuretools.vscode-docker
code --install-extension eamodio.gitlens
```

### 4. Leer Contexto Compartido

```bash
# El archivo más importante:
cat .ai-tools/shared-context.md
```

Este archivo contiene toda la información del proyecto que necesitan las IAs.

## 🎓 Cómo Usar Cada Herramienta

### GitHub Copilot (Principal)

**Cuándo usar:**
- Escribir código PHP WordPress/WooCommerce
- Generar scripts WP-CLI
- Implementar features específicas del proyecto
- Usar custom agents (@product-creator, @bogo-expert, etc.)

**Ejemplo:**
```php
// Escribe comentario descriptivo y Copilot genera código
// Crear función para obtener productos destacados por idioma con Bogo
function jewelry_get_featured_products( $locale = 'es_ES' ) {
    // Copilot completa automáticamente
}
```

**Ver:** [GitHub COPILOT-SKILLS.md](/.github/COPILOT-SKILLS.md)

---

### Claude (Análisis Profundo)

**Cuándo usar:**
- Generar contenido bilingüe extenso
- Code review y refactoring complejo
- Debugging de problemas difíciles
- Planificación de arquitectura

**Setup:**
1. Usar Claude Desktop App (gratis) o Claude API
2. Crear proyecto "Jewelry" con archivos del proyecto
3. Usar prompts de [.ai-tools/claude/README.md](./claude/README.md)

**Ejemplo de prompt:**
```
Contexto: [copiar shared-context.md]

Tarea: Refactoriza esta función para seguir WordPress Coding Standards
y añadir soporte completo Bogo para multiidioma.

[Código aquí]
```

**Ver:** [claude/README.md](./claude/README.md)

---

### Codeium (Autocompletado Gratuito)

**Cuándo usar:**
- Autocompletado en tiempo real (complemento a Copilot)
- Búsqueda semántica en codebase
- Chat inline para refactoring rápido
- Documentación automática (PHPDoc)

**Setup:**
```bash
code --install-extension codeium.codeium
# Login en VS Code: Ctrl+Shift+P > "Codeium: Sign In"
```

**Shortcuts:**
- `Ctrl+Alt+Space` - Aceptar sugerencia
- `Ctrl+I` - Abrir chat inline
- `Ctrl+Shift+P` > "Codeium: Search Codebase"

**Ver:** [codeium/README.md](./codeium/README.md)

---

### ChatGPT-4 (Marketing & Copy)

**Cuándo usar:**
- Descripciones de productos bilingües
- Copy para emails de WooCommerce
- SEO keywords research
- Nombres de categorías
- Landing pages

**Setup:**
1. Ir a https://chat.openai.com
2. (Recomendado) Suscribirse a Plus ($20/mes)
3. Crear Custom GPT "Jewelry Assistant"
4. Subir shared-context.md como knowledge base

**Ver:** [chatgpt/README.md](./chatgpt/README.md)

---

## 📚 Workflows Documentados

### 1. [Creación de Producto Bilingüe](./workflows/product-creation.md)

Workflow completo para crear un producto WooCommerce en ambos idiomas:
- Preparación de información
- Generación de descripciones con Claude
- Script automatizado con Copilot
- Vinculación Bogo
- Añadir imágenes y categorías

**Tiempo:** ~40-60 min/producto

---

### 2. [Importación Masiva de Productos](./workflows/bulk-import.md)

Para importar 10+ productos desde CSV o catálogo:
- Preparar archivo CSV bilingüe
- Script de importación automatizada
- Validación de vinculación Bogo
- Testing en ambos idiomas

**Tiempo:** ~2-3 horas para 50 productos

---

### 3. [Personalización de Emails](./workflows/email-customization.md)

Customizar templates de WooCommerce:
- Modificar templates bilingües
- Añadir branding de joyería
- Testing con MailHog
- Deploy a producción

**Tiempo:** ~3-4 horas

---

### 4. [Troubleshooting Bogo](./workflows/troubleshooting-bogo.md)

Resolver problemas comunes con Bogo:
- Productos no vinculados
- Idioma incorrecto en frontend
- Menús no cambian de idioma
- Diagnóstico y soluciones

---

## 💰 Costos Mensuales

| Herramienta        | Costo   | Valor                          |
| ------------------ | ------- | ------------------------------ |
| **GitHub Copilot** | $10/mes | ⭐⭐⭐⭐⭐ Esencial                 |
| **Codeium**        | GRATIS  | ⭐⭐⭐⭐ Excelente complemento     |
| **Claude Free**    | GRATIS  | ⭐⭐⭐ Para consultas ocasionales |
| **Claude Pro**     | $20/mes | ⭐⭐⭐⭐ Si usas mucho             |
| **ChatGPT Plus**   | $20/mes | ⭐⭐⭐⭐⭐ Para marketing/copy      |

**Setup Recomendado:**
- **Mínimo:** Copilot ($10) + Codeium (free) = **$10/mes**
- **Óptimo:** Copilot + Codeium + ChatGPT Plus = **$30/mes**
- **Premium:** Copilot + Codeium + Claude Pro + ChatGPT Plus = **$50/mes**

## 🎯 Casos de Uso por Herramienta

### Desarrollo de Features

**Flujo recomendado:**
1. **Copilot** - Generar código base con custom agents
2. **Codeium** - Autocompletado durante escritura
3. **Claude** - Code review y optimización
4. **ChatGPT** - Documentación usuario final

### Creación de Contenido

**Flujo recomendado:**
1. **ChatGPT** - Generar copy y descripciones bilingües
2. **Claude** - Refinar y optimizar para SEO
3. **Copilot** - Integrar en scripts WP-CLI
4. **Codeium** - Autocompletar en PHP

### Debugging

**Flujo recomendado:**
1. **Copilot Chat** - Primera consulta con contexto del proyecto
2. **Claude** - Análisis profundo si es complejo
3. **Codeium Search** - Buscar código similar en codebase
4. **ChatGPT** - Explicaciones y documentación

## 📋 Checklist de Implementación

### Fase 1: Setup Básico (15 min)
- [ ] Ejecutar `.ai-tools/test-ai-tools.sh`
- [ ] Verificar que Docker está corriendo
- [ ] Leer `shared-context.md`
- [ ] Instalar Copilot y Codeium en VS Code

### Fase 2: Configuración (30 min)
- [ ] Copiar `settings-ai-tools.json` a `.vscode/settings.json`
- [ ] Login en Codeium
- [ ] Crear cuenta ChatGPT Plus (opcional pero recomendado)
- [ ] Probar Copilot con custom agents (@product-creator)

### Fase 3: Testing (20 min)
- [ ] Crear un producto de prueba usando workflow
- [ ] Generar descripción con ChatGPT
- [ ] Usar Codeium para búsqueda en codebase
- [ ] Pedir code review a Claude

### Fase 4: Producción
- [ ] Crear 5-10 productos reales con workflow optimizado
- [ ] Documentar prompts efectivos en `prompts-library.md`
- [ ] Ajustar configuración según preferencias
- [ ] Compartir best practices con equipo

## 🚨 Troubleshooting

### Copilot no sugiere nada

```bash
# Verificar login
Ctrl+Shift+P > "GitHub Copilot: Sign In"

# Recargar VS Code
Ctrl+Shift+P > "Developer: Reload Window"
```

### Codeium conflictúa con Copilot

Ambos pueden coexistir. Si hay problemas, ajustar en `settings.json`:
```json
{
  "editor.inlineSuggest.enabled": true,
  "codeium.enableCodeLens": true
}
```

### Claude respuestas genéricas

Siempre incluir contexto del proyecto:
```
Contexto: Ver archivo .ai-tools/shared-context.md

Proyecto Jewelry - WordPress + WooCommerce bilingüe (ES/EN) con Bogo...
[resto de tu prompt]
```

### Script test-ai-tools.sh falla

```bash
# Verificar Docker
docker compose ps

# Iniciar contenedores
docker compose up -d

# Reejecutar test
./.ai-tools/test-ai-tools.sh
```

## 🔗 Referencias

- [GitHub Copilot Docs](https://docs.github.com/en/copilot)
- [Claude Documentation](https://docs.anthropic.com/)
- [Codeium Docs](https://codeium.com/docs)
- [ChatGPT Help](https://help.openai.com/)
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)
- [WooCommerce Docs](https://woocommerce.github.io/code-reference/)

## 💡 Tips Finales

1. **Contexto es clave:** Siempre referencia `shared-context.md` al usar cualquier IA
2. **Especialización:** Usa cada herramienta para lo que hace mejor
3. **Iteración:** No aceptes primera respuesta, refina con follow-ups
4. **Documentación:** Guarda prompts efectivos para reutilizar
5. **Testing:** Siempre probar en ambos idiomas (ES y EN) con Bogo
6. **Seguridad:** Validar que IAs sanitizan inputs y escapan outputs
7. **WordPress Standards:** Verificar que código sigue convenciones WP
8. **Prefijos:** Todas las funciones custom deben usar `jewelry_`

## 📞 Soporte

¿Problemas con el setup?
1. Revisar logs: `docker compose logs -f wordpress`
2. Consultar workflows específicos en `./workflows/`
3. Ejecutar `test-ai-tools.sh` para diagnóstico
4. Revisar troubleshooting en guías individuales

---

**🎉 ¡Setup completo! Ahora tienes un ecosistema de IAs optimizado para desarrollo WordPress bilingüe.**

**Próximo paso:** Leer [workflows/product-creation.md](./workflows/product-creation.md) y crear tu primer producto con el workflow optimizado.

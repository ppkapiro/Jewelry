# Custom Agents - Jewelry Project

Agentes personalizados de GitHub Copilot para desarrollo eficiente del sitio Jewelry.

## 📚 Agentes Disponibles

### 1. 🛍️ **Product Creator**

**Archivo:** `product-creator.agent.md`

**Especialidad:** Crear productos WooCommerce bilingües

**Cuándo usar:**

- Crear productos simples o variables
- Importar productos desde CSV
- Actualizar precios masivamente
- Gestionar categorías de productos

**Ejemplo de uso:**

```
@product-creator Crea un producto de cadena cubana 10k de 6mm por $499
```

**Handoffs disponibles:**

- → Bogo Expert (vincular traducciones)
- → Security Reviewer (revisar seguridad)

---

### 2. 📄 **Page Builder**

**Archivo:** `page-builder.agent.md`

**Especialidad:** Crear páginas WordPress bilingües

**Cuándo usar:**

- Crear páginas About Us, Materials, Contact
- Páginas legales (Privacy, Terms)
- Blog posts bilingües
- Páginas con templates personalizados

**Ejemplo de uso:**

```
@page-builder Crea la página "Nosotros / About Us" con contenido sobre Remedio Joyería
```

**Handoffs disponibles:**

- → Bogo Expert (vincular traducciones)
- → Product Creator (crear productos relacionados)

---

### 3. 🔗 **Bogo Expert**

**Archivo:** `bogo-expert.agent.md`

**Especialidad:** Vincular contenido multiidioma con Bogo

**Cuándo usar:**

- Vincular productos/páginas en ambos idiomas
- Detectar contenido sin traducir
- Reparar vinculaciones rotas
- Verificar meta `_locale` y `_bogo_translations`

**Ejemplo de uso:**

```
@bogo-expert Vincula el producto ID 123 (ES) con el ID 456 (EN)
@bogo-expert Busca todos los productos sin traducción al inglés
```

**Handoffs disponibles:**

- → Bogo Expert (búsqueda recursiva)

---

### 4. 🛒 **WooCommerce Expert**

**Archivo:** `woocommerce-expert.agent.md`

**Especialidad:** Configuración y personalización WooCommerce

**Cuándo usar:**

- Emails bilingües de WooCommerce
- Campos personalizados en checkout
- Configurar categorías y atributos
- Personalizar hooks y filtros
- Configuración de pagos

**Ejemplo de uso:**

```
@woocommerce-expert Agrega un campo "mensaje de regalo" en el checkout bilingüe
@woocommerce-expert Configura emails para enviar en el idioma de la orden
```

**Handoffs disponibles:**

- → Product Creator (crear productos)
- → Security Reviewer (revisar seguridad)

---

### 5. 🔒 **Security Reviewer**

**Archivo:** `security-reviewer.agent.md`

**Especialidad:** Revisar seguridad de código

**Cuándo usar:**

- Revisar código antes de producción
- Detectar vulnerabilidades XSS, SQL Injection, CSRF
- Validar sanitización y escape
- Verificar verificación de nonces
- Auditar permisos de usuario

**Ejemplo de uso:**

```
@security-reviewer Revisa este código por vulnerabilidades de seguridad
@security-reviewer ¿Este formulario es seguro?
```

**Sin handoffs** (es el último punto de revisión)

---

### 6. 💾 **Database Manager**

**Archivo:** `database-manager.agent.md`

**Especialidad:** Gestión de base de datos y WP-CLI

**Cuándo usar:**

- Backups y restauración de base de datos
- Ejecutar comandos WP-CLI en Docker
- Optimizar/reparar tablas
- Limpieza de base de datos
- Búsqueda y reemplazo en DB

**Ejemplo de uso:**

```
@database-manager Crea un backup de la base de datos
@database-manager Lista todos los productos con WP-CLI
@database-manager Optimiza la base de datos
```

**Sin handoffs** (operaciones de infraestructura)

---

## 🎯 Cómo Usar los Agentes

### En Chat de Copilot

1. Abre el Chat de Copilot (Ctrl+Alt+I)
2. Selecciona un agente del dropdown
3. Escribe tu prompt
4. El agente responderá con su especialización

### Cambiar de Agente (Handoff)

Algunos agentes sugieren **handoffs** - botones para cambiar a otro agente relacionado:

```
Product Creator → [Vincular con Bogo] → Bogo Expert
WooCommerce Expert → [Revisar Seguridad] → Security Reviewer
```

### Workflow Recomendado

**Para crear producto completo:**

1. `@product-creator` - Crear producto bilingüe
2. Click "Vincular con Bogo" → `@bogo-expert` - Verificar vinculación
3. Click "Revisar Seguridad" → `@security-reviewer` - Validar código

**Para crear página:**

1. `@page-builder` - Crear página bilingüe
2. Click "Vincular con Bogo" → `@bogo-expert` - Verificar vinculación

---

## 📁 Ubicación de Archivos

```
.github/
└── agents/
    ├── product-creator.agent.md      # Crear productos
    ├── page-builder.agent.md         # Crear páginas
    ├── bogo-expert.agent.md          # Vincular traducciones
    ├── woocommerce-expert.agent.md   # Config WooCommerce
    ├── security-reviewer.agent.md    # Revisar seguridad
    ├── database-manager.agent.md     # Gestión DB
    └── README.md                     # Este archivo
```

---

## ⚙️ Configuración Requerida

Los agentes están habilitados en [.vscode/settings.json](../../.vscode/settings.json):

```json
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.useAgentsMdFile": true,
  "chat.useAgentSkills": true,
  "chat.includeApplyingInstructions": true,
  "chat.includeReferencedInstructions": true
}
```

---

## 🆕 Crear Nuevos Agentes

Para crear un nuevo agente personalizado:

1. Crea archivo `.agent.md` en esta carpeta
2. Agrega el frontmatter YAML:

```yaml
---
name: Mi Agente
description: Breve descripción
tools: ["readFiles", "writeFiles", "runCommand"]
handoffs:
  - label: Ir a otro agente
    agent: otro-agente
    prompt: Mensaje de transición
---
```

3. Escribe las instrucciones del agente en Markdown
4. VS Code lo detectará automáticamente

---

## 📚 Documentación Relacionada

- [Instrucciones Generales](../copilot-instructions.md) - Contexto del proyecto
- [Skills Documentados](../COPILOT-SKILLS.md) - Ejemplos de código
- [VS Code Custom Agents Docs](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

---

## 🔄 Actualizar Agentes

Los agentes se cargan automáticamente al modificar los archivos `.agent.md`. Si no ves cambios:

1. Recarga VS Code (Ctrl+Shift+P → "Reload Window")
2. Verifica que los settings estén habilitados
3. Usa "Chat: Configure Custom Agents" para ver agentes disponibles

---

**Creado:** 2026-02-10
**Proyecto:** Jewelry - Remedio Joyería (WordPress + WooCommerce Bilingüe)

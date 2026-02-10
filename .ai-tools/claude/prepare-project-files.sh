#!/bin/bash

################################################################################
# Preparar archivos para Claude Project
# Genera archivos markdown consolidados para subir a Claude
################################################################################

set -e

OUTPUT_DIR=".ai-tools/claude/project-files"
mkdir -p "$OUTPUT_DIR"

echo "📦 Preparando archivos para Claude Project..."
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# Archivo 1: Contexto del Proyecto
# ═══════════════════════════════════════════════════════════════════════════
echo "📄 Generando: context-proyecto-jewelry.md"

cat > "$OUTPUT_DIR/context-proyecto-jewelry.md" << 'EOF'
# Contexto del Proyecto Jewelry

Este archivo contiene toda la información relevante del proyecto para Claude.

---

EOF

cat .ai-tools/shared-context.md >> "$OUTPUT_DIR/context-proyecto-jewelry.md"

echo "   ✓ context-proyecto-jewelry.md creado"

# ═══════════════════════════════════════════════════════════════════════════
# Archivo 2: Instrucciones y Reglas
# ═══════════════════════════════════════════════════════════════════════════
echo "📄 Generando: instrucciones-desarrollo.md"

cat > "$OUTPUT_DIR/instrucciones-desarrollo.md" << 'EOF'
# Instrucciones de Desarrollo

Reglas y convenciones del proyecto Jewelry.

---

EOF

cat .github/copilot-instructions.md >> "$OUTPUT_DIR/instrucciones-desarrollo.md"

echo "   ✓ instrucciones-desarrollo.md creado"

# ═══════════════════════════════════════════════════════════════════════════
# Archivo 3: Estado del Proyecto
# ═══════════════════════════════════════════════════════════════════════════
echo "📄 Generando: estado-proyecto.md"

cat > "$OUTPUT_DIR/estado-proyecto.md" << 'EOF'
# Estado del Proyecto Jewelry

Progreso actual y tareas pendientes.

---

EOF

if [ -f "PROYECTO-ESTADO.md" ]; then
    cat PROYECTO-ESTADO.md >> "$OUTPUT_DIR/estado-proyecto.md"
    echo "   ✓ estado-proyecto.md creado"
else
    echo "   ⚠ PROYECTO-ESTADO.md no encontrado, generando placeholder..."
    cat >> "$OUTPUT_DIR/estado-proyecto.md" << 'EOF'
## Estado Actual

- Setup de entorno completado
- Docker containers corriendo
- WordPress + WooCommerce configurados
- Bogo multiidioma activo

## Próximas Tareas

1. Crear productos del catálogo
2. Configurar emails WooCommerce bilingües
3. Setup SEO
4. Personalizar diseño
EOF
    echo "   ✓ estado-proyecto.md creado (placeholder)"
fi

# ═══════════════════════════════════════════════════════════════════════════
# Archivo 4: Skills y Ejemplos
# ═══════════════════════════════════════════════════════════════════════════
echo "📄 Generando: skills-ejemplos.md"

cat > "$OUTPUT_DIR/skills-ejemplos.md" << 'EOF'
# Skills y Ejemplos de Código

Funciones y patrones comunes del proyecto.

---

EOF

if [ -f ".claude/skills/SKILLS.md" ]; then
    cat .claude/skills/SKILLS.md >> "$OUTPUT_DIR/skills-ejemplos.md"
    echo "   ✓ skills-ejemplos.md creado"
else
    echo "   ⚠ .claude/skills/SKILLS.md no encontrado, omitiendo..."
fi

# ═══════════════════════════════════════════════════════════════════════════
# Resumen
# ═══════════════════════════════════════════════════════════════════════════
echo ""
echo "═══════════════════════════════════════════════════════════════════════"
echo "✅ Archivos preparados en: $OUTPUT_DIR/"
echo "═══════════════════════════════════════════════════════════════════════"
echo ""
ls -lh "$OUTPUT_DIR/"
echo ""
echo "📋 Próximos pasos:"
echo ""
echo "1. Ir a https://claude.ai o abrir Claude Desktop App"
echo "2. Crear nuevo proyecto llamado 'Jewelry'"
echo "3. Subir estos archivos como Project Knowledge:"
echo "   - context-proyecto-jewelry.md"
echo "   - instrucciones-desarrollo.md"
echo "   - estado-proyecto.md"
echo "   - skills-ejemplos.md (opcional)"
echo ""
echo "4. En Project Settings > Custom Instructions, pegar:"
echo "   (Ver .ai-tools/claude/SETUP-GUIDE.md para el texto)"
echo ""
echo "¡Listo para usar Claude Pro con contexto completo del proyecto!"
echo ""

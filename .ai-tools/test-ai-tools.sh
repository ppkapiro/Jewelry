#!/bin/bash

################################################################################
# Test AI Tools - Jewelry Project
# Verifica instalación y configuración de herramientas IA
################################################################################

set -e

# Colors para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🤖 Test de Herramientas IA - Proyecto Jewelry              ║${NC}"
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo ""

# Contador de tests
PASSED=0
FAILED=0
TOTAL=0

# Función para test
run_test() {
    local test_name="$1"
    local test_command="$2"

    TOTAL=$((TOTAL + 1))
    echo -n "Testing ${test_name}... "

    if eval "$test_command" &> /dev/null; then
        echo -e "${GREEN}✓ PASS${NC}"
        PASSED=$((PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        FAILED=$((FAILED + 1))
        return 1
    fi
}

# Función para test con output
run_test_with_output() {
    local test_name="$1"
    local test_command="$2"

    TOTAL=$((TOTAL + 1))
    echo -n "Testing ${test_name}... "

    output=$(eval "$test_command" 2>&1)
    result=$?

    if [ $result -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC}"
        echo -e "  ${YELLOW}→${NC} $output"
        PASSED=$((PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        echo -e "  ${RED}→${NC} $output"
        FAILED=$((FAILED + 1))
        return 1
    fi
}

echo -e "${YELLOW}━━━ Estructura del Proyecto ━━━${NC}"
run_test "Directorio .ai-tools/" "[ -d '.ai-tools' ]"
run_test "Contexto compartido" "[ -f '.ai-tools/shared-context.md' ]"
run_test "Guía de Claude" "[ -f '.ai-tools/claude/README.md' ]"
run_test "Skills de Copilot" "[ -f '.github/COPILOT-SKILLS.md' ]"
run_test "Skills de Claude" "[ -f '.claude/skills/SKILLS.md' ]"
echo ""

echo -e "${YELLOW}━━━ Docker Containers ━━━${NC}"
run_test "Docker compose instalado" "command -v docker compose"
run_test "Contenedor WordPress" "docker ps | grep -q jewelry_wordpress"
run_test "Contenedor MySQL" "docker ps | grep -q jewelry_mysql"
run_test "Contenedor phpMyAdmin" "docker ps | grep -q jewelry_phpmyadmin"
echo ""

echo -e "${YELLOW}━━━ WordPress Environment ━━━${NC}"
run_test_with_output "WordPress version" "docker exec jewelry_wordpress wp core version --allow-root"
run_test_with_output "WooCommerce version" "docker exec jewelry_wordpress wp plugin get woocommerce --field=version --allow-root"
run_test_with_output "Bogo version" "docker exec jewelry_wordpress wp plugin get bogo --field=version --allow-root"
run_test_with_output "Kadence version" "docker exec jewelry_wordpress wp theme get kadence --field=version --allow-root"
echo ""

echo -e "${YELLOW}━━━ Plugins Activos ━━━${NC}"
run_test "WooCommerce activo" "docker exec jewelry_wordpress wp plugin is-active woocommerce --allow-root"
run_test "Bogo activo" "docker exec jewelry_wordpress wp plugin is-active bogo --allow-root"
run_test "Kadence Blocks activo" "docker exec jewelry_wordpress wp plugin is-active kadence-blocks --allow-root"
echo ""

echo -e "${YELLOW}━━━ Configuración Multiidioma ━━━${NC}"
run_test_with_output "Locale actual" "docker exec jewelry_wordpress wp option get WPLANG --allow-root || echo 'en_US'"
run_test "Función Bogo disponible" "docker exec jewelry_wordpress wp eval 'echo function_exists(\"bogo_get_current_locale\") ? \"yes\" : \"no\";' --allow-root | grep -q 'yes'"
echo ""

echo -e "${YELLOW}━━━ Contenido Bilingüe ━━━${NC}"
run_test_with_output "Productos totales" "docker exec jewelry_wordpress wp post list --post_type=product --format=count --allow-root"
run_test_with_output "Páginas totales" "docker exec jewelry_wordpress wp post list --post_type=page --format=count --allow-root"
echo ""

echo -e "${YELLOW}━━━ Archivos Custom ━━━${NC}"
run_test "functions-custom.php existe" "[ -f 'data/wordpress/wp-content/themes/kadence/functions-custom.php' ]"
echo ""

echo -e "${YELLOW}━━━ Conectividad ━━━${NC}"
run_test "Frontend accesible" "curl -k -s -o /dev/null -w '%{http_code}' https://jewelry.local.dev | grep -q '^[23]'"
run_test "Admin accesible" "curl -k -s -o /dev/null -w '%{http_code}' https://jewelry.local.dev/wp-admin/ | grep -q '^[23]'"
echo ""

echo -e "${YELLOW}━━━ VS Code Extensions (Opcional) ━━━${NC}"
if command -v code &> /dev/null; then
    run_test "GitHub Copilot" "code --list-extensions | grep -q 'github.copilot'"
    run_test "Continue.dev (Claude)" "code --list-extensions | grep -q 'continue.continue'"
    run_test "Codeium" "code --list-extensions | grep -q 'codeium.codeium'"
else
    echo -e "${YELLOW}  → code command no disponible (VS Code no en PATH)${NC}"
fi
echo ""

echo -e "${YELLOW}━━━ Git Repository ━━━${NC}"
run_test "Git inicializado" "[ -d '.git' ]"
run_test_with_output "Branch actual" "git branch --show-current"
run_test_with_output "Remote configurado" "git remote get-url origin"
echo ""

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   📊 Resultados del Test                                      ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Total de tests: ${BLUE}${TOTAL}${NC}"
echo -e "Pasados:        ${GREEN}${PASSED}${NC}"
echo -e "Fallados:       ${RED}${FAILED}${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ Todos los tests pasaron exitosamente!${NC}"
    echo ""
    echo -e "${YELLOW}🎉 El entorno está listo para desarrollo con herramientas IA${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Algunos tests fallaron${NC}"
    echo ""
    echo -e "${YELLOW}💡 Revisa los mensajes de error arriba para más detalles${NC}"
    echo ""
    exit 1
fi

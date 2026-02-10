#!/bin/bash

################################################################################
# Test Connections - Jewelry Project
# Verifica conectividad y salud de todos los servicios Docker
################################################################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

PASSED=0
FAILED=0

# Función para test
run_test() {
    local test_name="$1"
    local test_command="$2"

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

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🔍 Test de Conexiones - Jewelry Project                    ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}━━━ Docker & Containers ━━━${NC}"
run_test "Docker running" "docker info"
run_test "Docker Compose available" "docker compose version"
run_test "Container: WordPress" "docker ps | grep -q jewelry_wordpress"
run_test "Container: MySQL" "docker ps | grep -q jewelry_mysql"
run_test "Container: phpMyAdmin" "docker ps | grep -q jewelry_phpmyadmin"
echo ""

echo -e "${YELLOW}━━━ MySQL Database ━━━${NC}"
run_test "MySQL ping" "docker exec jewelry_mysql mysqladmin ping -h localhost --silent"
run_test "MySQL connects" "docker exec jewelry_mysql mysql -u root -p\${MYSQL_ROOT_PASSWORD} -e 'SELECT 1' 2>/dev/null"
run_test "Database exists" "docker exec jewelry_mysql mysql -u root -p\${MYSQL_ROOT_PASSWORD} -e 'USE jewelry_db' 2>/dev/null"
echo ""

echo -e "${YELLOW}━━━ WordPress ━━━${NC}"
run_test "WP-CLI available" "docker exec jewelry_wordpress wp --version --allow-root"
run_test "WordPress installed" "docker exec jewelry_wordpress wp core is-installed --allow-root"
run_test "WooCommerce active" "docker exec jewelry_wordpress wp plugin is-active woocommerce --allow-root"
run_test "Bogo active" "docker exec jewelry_wordpress wp plugin is-active bogo --allow-root"
run_test "Kadence active" "docker exec jewelry_wordpress wp theme is-active kadence --allow-root"
echo ""

echo -e "${YELLOW}━━━ Network Connectivity ━━━${NC}"
run_test "Frontend accessible" "curl -k -s -o /dev/null -w '%{http_code}' https://jewelry.local.dev | grep -q '^[23]'"
run_test "Admin accessible" "curl -k -s -o /dev/null -w '%{http_code}' https://jewelry.local.dev/wp-admin/ | grep -q '^[23]'"
run_test "phpMyAdmin accessible" "curl -k -s -o /dev/null -w '%{http_code}' https://phpmyadmin.jewelry.local.dev | grep -q '^[23]'"
echo ""

echo -e "${YELLOW}━━━ File System ━━━${NC}"
run_test "WordPress writable" "docker exec jewelry_wordpress wp eval 'echo is_writable(WP_CONTENT_DIR) ? \"yes\" : \"no\";' --allow-root | grep -q 'yes'"
run_test "Uploads directory exists" "docker exec jewelry_wordpress test -d /var/www/html/wp-content/uploads"
run_test "functions-custom.php exists" "test -f data/wordpress/wp-content/themes/kadence/functions-custom.php"
echo ""

echo -e "${YELLOW}━━━ Configuration ━━━${NC}"
run_test ".env file exists" "test -f .env"
run_test "docker-compose.yml exists" "test -f docker-compose.yml"
run_test ".gitignore configured" "test -f .gitignore"
echo ""

# Resumen
TOTAL=$((PASSED + FAILED))
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
    echo -e "${YELLOW}🎉 El entorno está completamente funcional${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Algunos tests fallaron${NC}"
    echo ""
    echo -e "${YELLOW}💡 Sugerencias:${NC}"
    echo "   - Verifica que todos los contenedores estén corriendo: docker compose ps"
    echo "   - Revisa logs: docker compose logs"
    echo "   - Ejecuta setup: ./scripts/setup-dev.sh"
    echo ""
    exit 1
fi

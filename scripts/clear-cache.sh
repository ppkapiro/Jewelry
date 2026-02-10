#!/bin/bash

################################################################################
# Clear Cache - Jewelry Project
# Limpia todos los caches de WordPress y WooCommerce
################################################################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🧹 Limpiando caches - Jewelry Project${NC}"
echo ""

# Verificar que WordPress esté corriendo
if ! docker ps | grep -q jewelry_wordpress; then
    echo -e "${RED}❌ Error: Contenedor WordPress no está corriendo${NC}"
    echo "Ejecuta: docker compose up -d"
    exit 1
fi

# WordPress Object Cache
echo -e "${GREEN}📦 Limpiando WordPress object cache...${NC}"
docker exec jewelry_wordpress wp cache flush --allow-root

# Transients
echo -e "${GREEN}⏱️  Eliminando transients expirados...${NC}"
docker exec jewelry_wordpress wp transient delete --expired --allow-root

# Rewrite rules
echo -e "${GREEN}🔄 Regenerando rewrite rules...${NC}"
docker exec jewelry_wordpress wp rewrite flush --allow-root

# WooCommerce cache (si está instalado)
echo -e "${GREEN}🛒 Limpiando cache de WooCommerce...${NC}"
docker exec jewelry_wordpress wp cache flush --allow-root 2>/dev/null || true

# WooCommerce transients específicos
echo -e "${GREEN}🗑️  Eliminando transients de WooCommerce...${NC}"
docker exec jewelry_wordpress wp eval '
    delete_transient( "wc_admin_report" );
    delete_transient( "woocommerce_cache_excluded_uris" );
    wp_cache_flush();
' --allow-root 2>/dev/null || true

# Tema Kadence cache (si aplica)
echo -e "${GREEN}🎨 Limpiando cache del tema...${NC}"
docker exec jewelry_wordpress wp eval '
    if ( function_exists( "kadence_theme_delete_cache" ) ) {
        kadence_theme_delete_cache();
    }
' --allow-root 2>/dev/null || true

# Browser cache headers (invalidar)
echo -e "${GREEN}🌐 Nota: Recuerda limpiar cache del navegador${NC}"

echo ""
echo -e "${GREEN}✅ Todos los caches limpiados!${NC}"
echo ""
echo -e "${YELLOW}💡 Tips:${NC}"
echo "   - Limpia cache del navegador: Ctrl+Shift+R (Linux/Windows)"
echo "   - Si tienes Cloudflare u otro CDN, limpia allí también"
echo "   - Para desarrollo, desactiva caching de página"
echo ""

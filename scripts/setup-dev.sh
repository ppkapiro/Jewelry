#!/bin/bash

################################################################################
# Setup Development Environment - Jewelry Project
# Configura automáticamente el entorno de desarrollo local
################################################################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🚀 Setup Entorno de Desarrollo - Jewelry Project           ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar Docker
echo -e "${YELLOW}🔍 Verificando Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker no está instalado${NC}"
    echo "Instala Docker desde: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose no está instalado${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker instalado correctamente${NC}"
echo ""

# Verificar archivo .env
echo -e "${YELLOW}🔍 Verificando configuración...${NC}"
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        echo -e "${YELLOW}⚠️  Archivo .env no encontrado${NC}"
        echo -e "${BLUE}📝 Creando .env desde .env.example...${NC}"
        cp .env.example .env
        echo -e "${GREEN}✅ Archivo .env creado${NC}"
        echo -e "${YELLOW}⚠️  IMPORTANTE: Edita .env y configura contraseñas seguras${NC}"
        read -p "Presiona Enter cuando .env esté configurado..."
    else
        echo -e "${RED}❌ No se encontró .env ni .env.example${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Archivo .env existe${NC}"
fi
echo ""

# Iniciar contenedores
echo -e "${YELLOW}🐳 Iniciando contenedores Docker...${NC}"
docker compose up -d

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error al iniciar contenedores${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Contenedores iniciados${NC}"
echo ""

# Esperar a que MySQL esté listo
echo -e "${YELLOW}⏳ Esperando a que MySQL esté listo...${NC}"
sleep 10

MAX_ATTEMPTS=30
ATTEMPT=0
until docker exec jewelry_mysql mysqladmin ping -h localhost --silent 2>/dev/null; do
    ATTEMPT=$((ATTEMPT+1))
    if [ $ATTEMPT -ge $MAX_ATTEMPTS ]; then
        echo -e "${RED}❌ Timeout esperando MySQL${NC}"
        exit 1
    fi
    sleep 2
done

echo -e "${GREEN}✅ MySQL listo${NC}"
echo ""

# Verificar WordPress
echo -e "${YELLOW}🔍 Verificando WordPress...${NC}"
WP_VERSION=$(docker exec jewelry_wordpress wp core version --allow-root 2>/dev/null || echo "error")

if [ "$WP_VERSION" = "error" ]; then
    echo -e "${YELLOW}⚠️  WordPress no está instalado completamente${NC}"
else
    echo -e "${GREEN}✅ WordPress ${WP_VERSION} detectado${NC}"

    # Flush rewrite rules
    echo -e "${YELLOW}🔄 Regenerando permalinks...${NC}"
    docker exec jewelry_wordpress wp rewrite flush --allow-root 2>/dev/null || true

    # Flush cache
    echo -e "${YELLOW}🧹 Limpiando cache...${NC}"
    docker exec jewelry_wordpress wp cache flush --allow-root 2>/dev/null || true
fi
echo ""

# Verificar WooCommerce
WC_VERSION=$(docker exec jewelry_wordpress wp plugin get woocommerce --field=version --allow-root 2>/dev/null || echo "no instalado")
if [ "$WC_VERSION" != "no instalado" ]; then
    echo -e "${GREEN}✅ WooCommerce ${WC_VERSION} activo${NC}"
fi
echo ""

# Crear directorios necesarios
echo -e "${YELLOW}📁 Verificando estructura de directorios...${NC}"
mkdir -p backups
mkdir -p logs
echo -e "${GREEN}✅ Directorios creados${NC}"
echo ""

# Mostrar información
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   ✅ Setup Completado!                                        ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}🌐 URLs del proyecto:${NC}"
echo -e "   Frontend:     ${BLUE}https://jewelry.local.dev${NC}"
echo -e "   Admin:        ${BLUE}https://jewelry.local.dev/wp-admin${NC}"
echo -e "   phpMyAdmin:   ${BLUE}https://phpmyadmin.jewelry.local.dev${NC}"
echo ""
echo -e "${GREEN}🐳 Contenedores corriendo:${NC}"
docker compose ps
echo ""
echo -e "${YELLOW}📋 Próximos pasos:${NC}"
echo "   1. Accede a https://jewelry.local.dev"
echo "   2. Revisa PROYECTO-ESTADO.md para tareas pendientes"
echo "   3. Consulta .ai-tools/ para recursos de IAs"
echo ""
echo -e "${GREEN}🎉 ¡Listo para desarrollar!${NC}"

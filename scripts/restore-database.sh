#!/bin/bash

################################################################################
# Restore Database - Jewelry Project
# Restaura backup de base de datos desde archivo SQL comprimido
################################################################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuración
BACKUP_DIR="./backups"
MYSQL_CONTAINER="jewelry_mysql"
MYSQL_DATABASE="jewelry_db"
MYSQL_USER="jewelry_user"

echo -e "${YELLOW}🔄 Restaurar Base de Datos - Jewelry Project${NC}"
echo ""

# Verificar argumento
if [ -z "$1" ]; then
    echo -e "${YELLOW}📋 Backups disponibles:${NC}"
    echo ""
    ls -lh $BACKUP_DIR/*.sql.gz 2>/dev/null || echo "No hay backups disponibles"
    echo ""
    echo -e "${YELLOW}Uso:${NC} $0 <archivo_backup.sql.gz>"
    echo -e "${YELLOW}Ejemplo:${NC} $0 backups/db_20260210_120000.sql.gz"
    exit 1
fi

BACKUP_FILE="$1"

# Verificar que el archivo existe
if [ ! -f "$BACKUP_FILE" ]; then
    echo -e "${RED}❌ Error: Archivo no encontrado: $BACKUP_FILE${NC}"
    exit 1
fi

# Verificar que el contenedor MySQL esté corriendo
if ! docker ps | grep -q $MYSQL_CONTAINER; then
    echo -e "${RED}❌ Error: Contenedor MySQL no está corriendo${NC}"
    echo "Ejecuta: docker compose up -d"
    exit 1
fi

# Obtener password de .env
if [ -f .env ]; then
    source .env
else
    echo -e "${RED}❌ Error: Archivo .env no encontrado${NC}"
    exit 1
fi

# Confirmación
echo -e "${RED}⚠️  ADVERTENCIA: Esto sobrescribirá la base de datos actual${NC}"
echo -e "${YELLOW}Archivo a restaurar: ${BACKUP_FILE}${NC}"
echo ""
read -p "¿Continuar? (yes/no): " -r
echo ""

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Operación cancelada"
    exit 0
fi

# Crear backup de seguridad antes de restaurar
echo -e "${YELLOW}📦 Creando backup de seguridad actual...${NC}"
SAFETY_BACKUP="${BACKUP_DIR}/before_restore_$(date +%Y%m%d_%H%M%S).sql"
docker exec $MYSQL_CONTAINER mysqldump \
    -u $MYSQL_USER \
    -p"${MYSQL_PASSWORD}" \
    $MYSQL_DATABASE > "$SAFETY_BACKUP"
gzip "$SAFETY_BACKUP"
echo -e "${GREEN}✅ Backup de seguridad creado: ${SAFETY_BACKUP}.gz${NC}"
echo ""

# Descomprimir si es necesario
TEMP_FILE="/tmp/restore_temp.sql"
if [[ $BACKUP_FILE == *.gz ]]; then
    echo -e "${GREEN}🗜️  Descomprimiendo backup...${NC}"
    gunzip -c "$BACKUP_FILE" > "$TEMP_FILE"
else
    cp "$BACKUP_FILE" "$TEMP_FILE"
fi

# Restaurar
echo -e "${GREEN}🔄 Restaurando base de datos...${NC}"
docker exec -i $MYSQL_CONTAINER mysql \
    -u $MYSQL_USER \
    -p"${MYSQL_PASSWORD}" \
    $MYSQL_DATABASE < "$TEMP_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Base de datos restaurada exitosamente!${NC}"
    echo ""
    echo -e "${YELLOW}🔄 Limpiando cache de WordPress...${NC}"
    docker exec jewelry_wordpress wp cache flush --allow-root 2>/dev/null || true
    echo ""
    echo -e "${GREEN}🎉 Proceso completado!${NC}"
else
    echo -e "${RED}❌ Error al restaurar base de datos${NC}"
    echo -e "${YELLOW}Puedes restaurar el backup de seguridad desde:${NC}"
    echo "$SAFETY_BACKUP.gz"
    exit 1
fi

# Limpiar archivo temporal
rm -f "$TEMP_FILE"

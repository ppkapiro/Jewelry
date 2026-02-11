# Scripts de Mantenimiento

Utilidades para gestión y mantenimiento del proyecto Jewelry.

## 📦 Scripts Disponibles

### Backup y Restauración

- **[backup-database.sh](./backup-database.sh)** - Backup automático de MySQL con timestamp
- **[restore-database.sh](./restore-database.sh)** - Restaurar backup específico

### Setup y Configuración

- **[setup-dev.sh](./setup-dev.sh)** - Setup completo del entorno de desarrollo local
- **[clear-cache.sh](./clear-cache.sh)** - Limpiar cache de WordPress

### Git y Sincronización

- **[sync-fork.sh](./sync-fork.sh)** - Sincronizar cambios desde un fork (main/develop)

### Testing

- **[test-connections.sh](./test-connections.sh)** - Verificar conectividad de servicios Docker

## 🚀 Uso

Hacer ejecutables los scripts antes de usar:

```bash
chmod +x scripts/*.sh
```

Ejecutar un script:

```bash
./scripts/backup-database.sh
```

## 📋 Requisitos

- Docker y Docker Compose instalados
- Contenedores del proyecto corriendo
- Permisos de ejecución en los scripts

## 🔧 Desarrollo de Nuevos Scripts

Al crear nuevos scripts:

1. Usar shebang: `#!/bin/bash`
2. Añadir `set -e` para exit on error
3. Documentar uso en comentarios
4. Añadir validaciones de entrada
5. Usar variables para configuración
6. Añadir logging legible con emojis
7. Actualizar este README

## 📝 Convenciones

- **Nombres:** kebab-case (backup-database.sh)
- **Variables:** UPPER_CASE para constantes, lower_case para locales
- **Output:** Usar echo con prefijos: ✅ ⚠️ ❌ 🔍 📦
- **Errores:** Siempre retornar exit code apropiado

---

**Última actualización:** 11 de febrero de 2026

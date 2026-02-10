# Workflow: Importación Masiva de Productos

## 🎯 Objetivo

Importar 10+ productos simultáneamente desde CSV o spreadsheet, con vinculación Bogo automática y validación completa.

## 🔧 Herramientas Recomendadas

1. **Google Sheets / Excel** - Preparar datos
2. **ChatGPT-4** - Generar descripciones batch
3. **GitHub Copilot** - Script de importación
4. **WP-CLI** - Ejecución de importación

## 📋 Preparación del CSV

### Paso 1: Crear Template

**Crear archivo:** `data/import-products.csv`

```csv
sku,name_es,name_en,price,regular_price,description_es,description_en,short_desc_es,short_desc_en,categories_es,categories_en,image_url,gallery_urls,weight,stock_status,manage_stock,stock_quantity
RNG-SOL-001,"Anillo Solitario Eternal","Eternal Solitaire Ring",2499.00,2499.00,"Descripción larga ES...","Long description EN...","Desc corta ES","Short desc EN","Anillos,Compromiso","Rings,Engagement","https://example.com/img1.jpg","https://example.com/img2.jpg|https://example.com/img3.jpg",4.5,instock,yes,5
```

### Paso 2: Script de Importación

Ver template completo del script en el repositorio: `scripts/bulk-import-products.sh`

## ✅ Validación Post-Importación

```bash
chmod +x scripts/validate-import.sh
./scripts/validate-import.sh
```

## 📊 Tiempo Estimado

**Total para 50 productos:** ~2-3 horas

## 💡 Best Practices

1. **Backup antes de importar**
2. **Test con 2-3 productos primero**
3. **Validar CSV**
4. **Batch size:** 10-20 productos
5. **Monitorear logs**

# Workflow: Creación de Producto Bilingüe

## 🎯 Objetivo
Crear un producto WooCommerce completo en ambos idiomas (ES/EN) con vinculación Bogo correcta.

## 🔧 Herramientas Recomendadas

1. **GitHub Copilot** - Generación inicial del script
2. **Claude** - Descripciones de producto detalladas
3. **ChatGPT** - SEO keywords y meta descriptions

## 📋 Pasos del Workflow

### Paso 1: Preparar Información del Producto

**Información necesaria:**
- Nombre del producto (ES y EN)
- SKU único
- Precio (USD)
- Categorías (ES y EN)
- Materiales
- Dimensiones
- Peso
- Imágenes (URLs o archivos locales)

**Ejemplo:**
```yaml
producto:
  nombre_es: "Anillo de Compromiso Solitario"
  nombre_en: "Solitaire Engagement Ring"
  sku: "RNG-SOL-001"
  precio: 2499.00
  categorias:
    es: "Anillos, Compromiso"
    en: "Rings, Engagement"
  materiales: "Oro blanco 18k, Diamante 1ct"
  dimensiones: "Aro ajustable"
  peso: "4.5g"
  imagenes:
    - "uploads/2025/01/anillo-solitario-frontal.jpg"
    - "uploads/2025/01/anillo-solitario-lateral.jpg"
    - "uploads/2025/01/anillo-solitario-detalle.jpg"
```

### Paso 2: Generar Descripciones con Claude

**Prompt para Claude:**
```
Contexto: Proyecto Jewelry - ecommerce bilingüe de joyería en Miami

Producto: [nombre del producto]
Características: [listar características clave]
Materiales: [materiales]
Precio: $[precio]

Genera descripciones profesionales en AMBOS idiomas:

1. DESCRIPCIÓN LARGA (200-250 palabras)
   - Destacar calidad, diseño, artesanía
   - Mencionar garantía, envío gratis
   - Tono elegante y persuasivo
   - Incluir beneficios emocionales

2. DESCRIPCIÓN CORTA (50-70 palabras)
   - Resumen impactante
   - Características principales
   - Call to action sutil

3. META DESCRIPTION SEO (150-160 caracteres)
   - Optimizada para búsqueda
   - Incluir keyword principal

Formato de salida: Primero ES, luego EN con separadores claros
```

### Paso 3: Crear Script con Copilot

**En VS Code:**

1. Crear archivo `scripts/create-product-[nombre].sh`

2. Usar Copilot con comentario:
```bash
#!/bin/bash
# Crear producto bilingüe WooCommerce con vinculación Bogo
# Producto: [Nombre del producto]
# SKU: [SKU]
# Usa funciones jewelry_create_bilingual_product_cli()
```

3. Copilot generará el script basándose en las skills

**Template del script:**
```bash
#!/bin/bash

# Exit on error
set -e

echo "🔨 Creando producto: [Nombre del Producto]"
echo ""

# Variables
PRODUCT_NAME_ES="[Nombre ES]"
PRODUCT_NAME_EN="[Nombre EN]"
SKU="[SKU]"
PRICE="[Precio]"
DESCRIPTION_ES="[Descripción larga ES de Claude]"
DESCRIPTION_EN="[Descripción larga EN de Claude]"
SHORT_DESC_ES="[Descripción corta ES de Claude]"
SHORT_DESC_EN="[Descripción corta EN de Claude]"

# Crear producto en español
echo "📦 Creando versión en español..."
PRODUCT_ID_ES=$(docker exec jewelry_wordpress wp post create \
    --post_type=product \
    --post_title="$PRODUCT_NAME_ES" \
    --post_content="$DESCRIPTION_ES" \
    --post_excerpt="$SHORT_DESC_ES" \
    --post_status=publish \
    --porcelain \
    --allow-root)

echo "   ID Español: $PRODUCT_ID_ES"

# Configurar producto WooCommerce (ES)
docker exec jewelry_wordpress wp post meta update $PRODUCT_ID_ES _sku "$SKU" --allow-root
docker exec jewelry_wordpress wp post meta update $PRODUCT_ID_ES _regular_price "$PRICE" --allow-root
docker exec jewelry_wordpress wp post meta update $PRODUCT_ID_ES _price "$PRICE" --allow-root

# Marcar como español
docker exec jewelry_wordpress wp post meta update $PRODUCT_ID_ES _locale "es_ES" --allow-root

# Crear producto en inglés
echo "📦 Creando versión en inglés..."
PRODUCT_ID_EN=$(docker exec jewelry_wordpress wp post create \
    --post_type=product \
    --post_title="$PRODUCT_NAME_EN" \
    --post_content="$DESCRIPTION_EN" \
    --post_excerpt="$SHORT_DESC_EN" \
    --post_status=publish \
    --porcelain \
    --allow-root)

echo "   ID Inglés: $PRODUCT_ID_EN"

# Configurar producto WooCommerce (EN)
docker exec jewelry_wordpress wp post meta update $PRODUCT_ID_EN _sku "${SKU}-EN" --allow-root
docker exec jewelry_wordpress wp post meta update $PRODUCT_ID_EN _regular_price "$PRICE" --allow-root
docker exec jewelry_wordpress wp post meta update $PRODUCT_ID_EN _price "$PRICE" --allow-root

# Marcar como inglés
docker exec jewelry_wordpress wp post meta update $PRODUCT_ID_EN _locale "en_US" --allow-root

# Vincular con Bogo
echo "🔗 Vinculando productos con Bogo..."
docker exec jewelry_wordpress wp post meta update $PRODUCT_ID_ES _bogo_translations \
    "{\"es_ES\":$PRODUCT_ID_ES,\"en_US\":$PRODUCT_ID_EN}" --format=json --allow-root

docker exec jewelry_wordpress wp post meta update $PRODUCT_ID_EN _bogo_translations \
    "{\"es_ES\":$PRODUCT_ID_ES,\"en_US\":$PRODUCT_ID_EN}" --format=json --allow-root

echo ""
echo "✅ Producto creado exitosamente!"
echo "   🇪🇸 Español: https://jewelry.local.dev/producto/$PRODUCT_ID_ES"
echo "   🇬🇧 Inglés: https://jewelry.local.dev/en/product/$PRODUCT_ID_EN"
echo ""
```

### Paso 4: Ejecutar y Verificar

1. **Hacer ejecutable:**
```bash
chmod +x scripts/create-product-[nombre].sh
```

2. **Ejecutar:**
```bash
./scripts/create-product-[nombre].sh
```

3. **Verificar creación:**
```bash
# Listar productos
docker exec jewelry_wordpress wp post list \
    --post_type=product \
    --posts_per_page=5 \
    --orderby=date \
    --order=DESC \
    --allow-root

# Verificar vinculación Bogo
docker exec jewelry_wordpress wp post meta get [PRODUCT_ID_ES] _bogo_translations --allow-root
```

4. **Probar en navegador:**
   - Frontend ES: https://jewelry.local.dev/producto/[slug-es]
   - Frontend EN: https://jewelry.local.dev/en/product/[slug-en]
   - Admin: https://jewelry.local.dev/wp-admin/edit.php?post_type=product

### Paso 5: Añadir Imágenes

**Con WP-CLI:**
```bash
# Subir imagen
IMAGE_ID=$(docker exec jewelry_wordpress wp media import \
    path/to/image.jpg \
    --post_id=$PRODUCT_ID_ES \
    --featured_image \
    --porcelain \
    --allow-root)

# Galería de imágenes
docker exec jewelry_wordpress wp post meta update $PRODUCT_ID_ES _product_image_gallery "$IMAGE_ID_2,$IMAGE_ID_3" --allow-root
```

**O manualmente en Admin:**
1. Ir a Productos > Editar producto
2. Subir imagen destacada
3. Añadir galería de imágenes en "Imágenes del producto"
4. Repetir para versión EN

### Paso 6: Asignar Categorías

**Crear categorías bilingües (si no existen):**
```bash
# Categoría en español
CAT_ID_ES=$(docker exec jewelry_wordpress wp term create product_cat "Anillos" \
    --slug=anillos \
    --porcelain \
    --allow-root)

docker exec jewelry_wordpress wp post meta update $CAT_ID_ES _locale "es_ES" --allow-root

# Categoría en inglés
CAT_ID_EN=$(docker exec jewelry_wordpress wp term create product_cat "Rings" \
    --slug=rings \
    --porcelain \
    --allow-root)

docker exec jewelry_wordpress wp post meta update $CAT_ID_EN _locale "en_US" --allow-root

# Vincular categorías con Bogo
docker exec jewelry_wordpress wp term meta update $CAT_ID_ES _bogo_translations \
    "{\"es_ES\":$CAT_ID_ES,\"en_US\":$CAT_ID_EN}" --format=json --allow-root
```

**Asignar producto a categoría:**
```bash
docker exec jewelry_wordpress wp post term add $PRODUCT_ID_ES product_cat $CAT_ID_ES --allow-root
docker exec jewelry_wordpress wp post term add $PRODUCT_ID_EN product_cat $CAT_ID_EN --allow-root
```

## ✅ Checklist Post-Creación

- [ ] Producto visible en frontend ES
- [ ] Producto visible en frontend EN
- [ ] Precio correcto en ambos idiomas
- [ ] SKU único asignado
- [ ] Imagen destacada configurada
- [ ] Galería de imágenes añadida
- [ ] Categorías asignadas correctamente
- [ ] Descripciones completas y atractivas
- [ ] Meta vinculada con Bogo (`_bogo_translations`)
- [ ] Locale correcto (`_locale` = es_ES o en_US)
- [ ] Botón "Añadir al carrito" funcional
- [ ] Cambio de idioma funciona correctamente

## 🚨 Troubleshooting

### Problema: Producto no aparece en frontend
```bash
# Regenerar permalinks
docker exec jewelry_wordpress wp rewrite flush --allow-root

# Verificar estado
docker exec jewelry_wordpress wp post get [PRODUCT_ID] --field=post_status --allow-root
```

### Problema: Vinculación Bogo no funciona
```bash
# Verificar meta
docker exec jewelry_wordpress wp post meta list [PRODUCT_ID] --allow-root | grep -E "_locale|_bogo"

# Revincular manualmente
docker exec jewelry_wordpress wp post meta update [PRODUCT_ID_ES] _bogo_translations \
    "{\"es_ES\":[PRODUCT_ID_ES],\"en_US\":[PRODUCT_ID_EN]}" --format=json --allow-root
```

### Problema: Precio no se muestra
```bash
# Verificar meta de precio
docker exec jewelry_wordpress wp post meta get [PRODUCT_ID] _price --allow-root

# Actualizar precio manualmente
docker exec jewelry_wordpress wp post meta update [PRODUCT_ID] _price "2499.00" --allow-root
docker exec jewelry_wordpress wp post meta update [PRODUCT_ID] _regular_price "2499.00" --allow-root
```

## 📊 Tiempo Estimado

- **Preparación:** 10-15 min
- **Descripciones (Claude):** 5-10 min
- **Script (Copilot):** 10-15 min
- **Ejecución:** 2-3 min
- **Imágenes:** 5-10 min
- **Verificación:** 5 min

**Total:** ~40-60 minutos por producto completo

## 💡 Tips

- **Batch creation:** Crear múltiples scripts y ejecutarlos en secuencia
- **Templates:** Guardar descripciones exitosas de Claude como templates
- **Naming convention:** Usar formato consistente para SKUs (e.g., RNG-SOL-001)
- **Keywords:** Pedir a ChatGPT keywords SEO antes de crear descripciones
- **Testing:** Probar checkout con producto de prueba antes de añadir todo el catálogo

---

**Ver también:**
- [Workflow: Importación Masiva](./bulk-import.md)
- [Workflow: Email Customization](./email-customization.md)
- [Troubleshooting: Bogo Issues](./troubleshooting-bogo.md)

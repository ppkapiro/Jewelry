# Tests del Proyecto Jewelry

Suite de tests automatizados para garantizar calidad y estabilidad.

## 📊 Estructura de Tests

```
tests/
├── php/              # PHPUnit tests para funciones custom
│   ├── bootstrap.php
│   ├── test-products.php
│   └── test-bogo-links.php
├── e2e/              # Tests end-to-end con Playwright/Cypress
│   ├── checkout.spec.js
│   ├── language-switch.spec.js
│   └── product-view.spec.js
└── README.md         # Este archivo
```

## 🧪 Tipos de Tests

### Unit Tests (PHP)

Tests para funciones individuales en `functions-custom.php` y plugins custom.

**Ubicación:** `tests/php/`
**Framework:** PHPUnit
**Coverage:**

- Funciones de creación de productos bilingües
- Vinculación con Bogo
- Sanitización y validación
- Helpers y utilities

### End-to-End Tests (E2E)

Tests del flujo completo de usuario en el sitio.

**Ubicación:** `tests/e2e/`
**Framework:** Playwright o Cypress (TBD)
**Coverage:**

- Flujo de checkout completo
- Cambio de idioma (ES ↔ EN)
- Vista de productos
- Añadir al carrito
- Búsqueda de productos

## 🚀 Ejecutar Tests

### PHP Unit Tests

```bash
# Instalar PHPUnit (primera vez)
docker exec jewelry_wordpress composer require --dev phpunit/phpunit

# Ejecutar todos los tests
docker exec jewelry_wordpress vendor/bin/phpunit tests/php/

# Ejecutar test específico
docker exec jewelry_wordpress vendor/bin/phpunit tests/php/test-products.php

# Con coverage
docker exec jewelry_wordpress vendor/bin/phpunit --coverage-html coverage/ tests/php/
```

### E2E Tests

```bash
# Instalar dependencias (primera vez)
npm install

# Ejecutar todos los e2e tests
npm run test:e2e

# Ejecutar en modo watch
npm run test:e2e:watch

# Con UI de Playwright
npm run test:e2e:ui
```

## 📝 Escribir Nuevos Tests

### PHP Unit Test Template

```php
<?php
/**
 * Test: Product Creation Functions
 */

class Test_Jewelry_Products extends WP_UnitTestCase {

    public function test_create_bilingual_product() {
        $data_es = array(
            'name' => 'Test Product ES',
            'description' => 'Description ES',
            'price' => 499.99
        );

        $data_en = array(
            'name' => 'Test Product EN',
            'description' => 'Description EN',
            'price' => 499.99
        );

        $result = jewelry_create_bilingual_product( $data_es, $data_en );

        $this->assertArrayHasKey( 'es', $result );
        $this->assertArrayHasKey( 'en', $result );
        $this->assertNotEmpty( $result['es'] );
        $this->assertNotEmpty( $result['en'] );
    }
}
```

### E2E Test Template (Playwright)

```javascript
import { test, expect } from "@playwright/test";

test("checkout flow en español", async ({ page }) => {
  // Navegar a shop
  await page.goto("https://jewelry.local.dev/tienda/");

  // Añadir producto al carrito
  await page.click(".add_to_cart_button").first();

  // Ir a checkout
  await page.goto("https://jewelry.local.dev/checkout/");

  // Llenar formulario
  await page.fill("#billing_first_name", "Test");
  await page.fill("#billing_email", "test@example.com");

  // Verificar total
  const total = await page.textContent(".order-total .amount");
  expect(total).toContain("$");
});
```

## 🎯 Coverage Goals

**Target:** 80% code coverage en funciones custom

- **Críticas (100%):** Funciones de productos, Bogo linking, checkout
- **Importantes (80%):** Helpers, validación, sanitización
- **Nice-to-have (60%):** Utilities, formateo

## 🔄 CI Integration

Los tests se ejecutan automáticamente en:

- Push a `main` o `develop`
- Pull Requests
- Workflow programado (nightly)

Ver [../.github/workflows/](.github/workflows/) para configuración.

## 📚 Recursos

- [PHPUnit Docs](https://phpunit.readthedocs.io/)
- [WordPress Tests](https://make.wordpress.org/core/handbook/testing/automated-testing/phpunit/)
- [Playwright Docs](https://playwright.dev/)
- [WooCommerce Testing](https://github.com/woocommerce/woocommerce/wiki/How-to-set-up-WooCommerce-development-environment)

## 🐛 Debugging Tests

```bash
# Ver output detallado
docker exec jewelry_wordpress vendor/bin/phpunit --debug tests/php/

# Ejecutar con Xdebug
docker exec -e XDEBUG_MODE=coverage jewelry_wordpress vendor/bin/phpunit

# Logs de test específico
docker logs jewelry_wordpress --tail 100
```

---

**Última actualización:** 10 de febrero de 2026
**Estado:** En desarrollo - PHPUnit pendiente de implementar

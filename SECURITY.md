# Política de Seguridad - Jewelry Project

Este documento describe las prácticas de seguridad del proyecto y el proceso para reportar vulnerabilidades.

## 🔒 Versiones Soportadas

Actualmente mantenemos soporte de seguridad para las siguientes versiones:

| Versión | Soportada | Estado |
| ------- | --------- | ------ |
| 1.x.x   | ✅ Sí     | Actual |
| < 1.0   | ❌ No     | Legacy |

---

## 🚨 Reportar una Vulnerabilidad

### Proceso Confidencial

**NO crear un issue público** para vulnerabilidades de seguridad.

**Usar uno de estos canales:**

1. **Email seguro:** security@jewelry.com (ejemplo)
2. **GitHub Security Advisories:** https://github.com/usuario/jewelry/security/advisories/new
3. **PGP encriptado:** Ver clave pública al final del documento

### Qué Incluir en el Reporte

```markdown
**Resumen:** Breve descripción del problema

**Tipo de vulnerabilidad:**

- [ ] SQL Injection
- [ ] XSS (Cross-Site Scripting)
- [ ] CSRF (Cross-Site Request Forgery)
- [ ] Exposición de credenciales
- [ ] Escalación de privilegios
- [ ] Otro: **\_**

**Severidad estimada:**

- [ ] Critical (CVSS 9.0-10.0)
- [ ] High (CVSS 7.0-8.9)
- [ ] Medium (CVSS 4.0-6.9)
- [ ] Low (CVSS 0.1-3.9)

**Pasos para reproducir:**

1. ...
2. ...

**Impacto:**
Qué puede hacer un atacante con esta vulnerabilidad.

**Entorno:**

- Versión del proyecto: 1.0.0
- WordPress: 6.9.1
- WooCommerce: 10.5.0
- PHP: 8.1

**Mitigación propuesta (opcional):**
Si tienes sugerencias de cómo arreglarlo.

**Prueba de concepto (opcional):**
Código o screenshots (sin explotar en producción).
```

### Qué Esperar

1. **Acknowledgment:** Respuesta inicial en **48 horas**
2. **Evaluación:** Confirmación de la vulnerabilidad en **5 días hábiles**
3. **Plan de acción:** Timeline de fix en **7 días hábiles**
4. **Fix:** Patch publicado según severidad:
   - **Critical:** 24-48 horas
   - **High:** 1-2 semanas
   - **Medium:** 2-4 semanas
   - **Low:** Próximo release programado
5. **Disclosure:** Publicación coordinada después del fix

---

## 🛡️ Prácticas de Seguridad

### Desarrollo

**Todos los contributors deben seguir:**

1. **Nunca commitear credenciales** (ver [.gitignore](.gitignore))
2. **Sanitizar SIEMPRE el input** (`sanitize_text_field()`, etc.)
3. **Escapar SIEMPRE el output** (`esc_html()`, `esc_attr()`, `esc_url()`)
4. **Verificar nonce** en formularios (`wp_verify_nonce()`)
5. **Usar prepared statements** para queries SQL (o WP_Query)
6. **Validar permisos** (`current_user_can()`)

**Ejemplos:**

```php
// ✅ CORRECTO
$email = sanitize_email( $_POST['email'] );
echo esc_html( $user_input );
wp_verify_nonce( $_POST['nonce'], 'jewelry_action' );

// ❌ INCORRECTO
echo $_POST['email']; // Sin sanitizar ni escapar
$wpdb->query( "SELECT * FROM wp_posts WHERE ID = " . $_GET['id'] ); // SQL injection
```

### Infraestructura

**Servidor de producción:**

- ✅ SSL/TLS con certificado válido
- ✅ Firewall habilitado (UFW, iptables)
- ✅ Fail2ban configurado
- ✅ SSH solo con clave (no password)
- ✅ Actualizaciones automáticas de seguridad
- ✅ Backups diarios encriptados
- ✅ Permisos de archivos correctos (755/644)
- ✅ `WP_DEBUG` desactivado en producción

**WordPress específico:**

```php
// wp-config.php en producción
define( 'DISALLOW_FILE_EDIT', true );  // Deshabilitar editor de archivos
define( 'FORCE_SSL_ADMIN', true );     // SSL obligatorio en admin
define( 'WP_DEBUG', false );           // Sin debug en producción
```

### Dependencias

**Mantener actualizados:**

```bash
# Verificar versiones actuales
docker exec jewelry_wordpress wp core version --allow-root
docker exec jewelry_wordpress wp plugin list --allow-root
docker exec jewelry_wordpress wp theme list --allow-root

# Actualizar (después de backup)
docker exec jewelry_wordpress wp core update --allow-root
docker exec jewelry_wordpress wp plugin update --all --allow-root
```

**Workflow recomendado:**

1. Backup antes de actualizar
2. Actualizar en entorno de staging primero
3. Probar funcionalidad crítica
4. Si todo OK, actualizar producción

---

## 🔑 Gestión de Credenciales

### Almacenamiento

**NUNCA en código:**

```bash
# ❌ INCORRECTO
define( 'DB_PASSWORD', 'mi_password_123' );

# ✅ CORRECTO (usar variables de entorno)
define( 'DB_PASSWORD', getenv('MYSQL_PASSWORD') );
```

**Usar:**

- `.env` local (en `.gitignore`)
- Vault (HashiCorp Vault, 1Password, etc.) en producción
- GitHub Secrets para CI/CD

### Rotación de Credenciales

**Cada 90 días rotar:**

- Passwords de base de datos
- WordPress salts (`AUTH_KEY`, etc.)
- Claves de API (payment gateway, etc.)
- SSH keys de servidores

**Proceso:**

```bash
# 1. Backup completo
./scripts/backup-database.sh

# 2. Generar nuevas credenciales
# Salts: https://api.wordpress.org/secret-key/1.1/salt/

# 3. Actualizar .env y wp-config.php

# 4. Reiniciar servicios
docker compose down
docker compose up -d

# 5. Verificar que funciona
./scripts/test-connections.sh
```

### Acceso a Servidores

**SSH Keys only:**

```bash
# Generar key específica para este proyecto
ssh-keygen -t ed25519 -C "jewelry-project-key"

# Copiar a servidor
ssh-copy-id -i ~/.ssh/jewelry_key.pub user@server

# Configurar ~/.ssh/config
Host jewelry-prod
    HostName production-server.com
    User deploy
    IdentityFile ~/.ssh/jewelry_key
```

**Deshabilitar password auth** en `/etc/ssh/sshd_config`:

```
PasswordAuthentication no
PermitRootLogin no
```

---

## 🔍 Auditorías

### Automáticas

**CI/CD checks (en cada PR):**

- ✅ Escaneo de credenciales hardcoded
- ✅ Verificación de archivos sensibles en commits
- ✅ Validación de `.gitignore`
- ✅ PHP lint para syntax errors

Ver [.github/workflows/code-quality.yml](.github/workflows/code-quality.yml).

### Manuales

**Cada 3 meses:**

```bash
# Buscar credenciales en historial Git
git log --all --full-history --source --find-object <SHA>

# Verificar permisos de archivos
find data/wordpress -type f -perm 0777
find data/wordpress -type d -perm 0777

# Listar usuarios WordPress
docker exec jewelry_wordpress wp user list --allow-root

# Verificar plugins instalados vs. activos
docker exec jewelry_wordpress wp plugin list --status=inactive --allow-root
```

**Cada 6 meses:**

- Auditoría de código por tercero (opcional)
- Penetration testing (opcional)
- Revisión de logs de acceso

---

## 📊 Severity Levels

Clasificación según [CVSS v3.1](https://www.first.org/cvss/):

| Nivel        | Score    | Descripción                           | Response Time   |
| ------------ | -------- | ------------------------------------- | --------------- |
| **Critical** | 9.0-10.0 | RCE, full data breach                 | 24-48 horas     |
| **High**     | 7.0-8.9  | Escalación privilegios, SQL injection | 1-2 semanas     |
| **Medium**   | 4.0-6.9  | XSS, CSRF, info disclosure            | 2-4 semanas     |
| **Low**      | 0.1-3.9  | Info leak menor, DoS local            | Próximo release |

---

## 🏆 Hall of Fame

Agradecemos a quienes han reportado vulnerabilidades responsablemente:

<!-- Lista de security researchers que han ayudado -->

_Tu nombre puede estar aquí - reporta vulnerabilidades de manera responsable._

---

## 📬 Contacto

**Equipo de Seguridad:**

- Email: security@jewelry.com (ejemplo)
- GitHub Security: [@usuario/jewelry/security](https://github.com/usuario/jewelry/security)

**PGP Public Key (opcional):**

```
-----BEGIN PGP PUBLIC KEY BLOCK-----
[Clave pública aquí]
-----END PGP PUBLIC KEY BLOCK-----
```

---

## 📚 Referencias

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [WordPress Security Best Practices](https://wordpress.org/support/article/hardening-wordpress/)
- [WooCommerce Security](https://woocommerce.com/document/woocommerce-security/)
- [CVSS Calculator](https://www.first.org/cvss/calculator/3.1)

---

**Última actualización:** 10 de febrero de 2026  
**Próxima revisión:** Mayo 2026  
**Mantenedor:** Equipo de Seguridad Jewelry

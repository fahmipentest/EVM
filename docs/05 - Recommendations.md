# 05 — Rekomendasi Perbaikan

## 1. WordPress Hardening (SEGERA)

```php
// wp-config.php — tambahkan baris ini
define('DISALLOW_FILE_EDIT', true);   // Matikan editor file
define('DISALLOW_FILE_MODS', true);   // Blokir install plugin/tema
define('WP_DEBUG', false);            // Matikan debug
```

```bash
# Update WordPress + plugin + tema
wp core update
wp plugin update --all
wp theme update --all
```

```php
// functions.php — nonaktifkan XML-RPC
add_filter('xmlrpc_enabled', '__return_false');
```

```apache
# .htaccess di /wp-content/uploads/
Options -Indexes
```

## 2. Credential

```bash
# HAPUS SEGERA file password plaintext
rm /home/root3r/.root_password_ssh.txt

# Ganti password root
passwd root
# Gunakan password kuat: >=16 karakter

# Ganti password WordPress c0rrupt3d_brain dari wp-admin
```

**Install 2FA WordPress:** plugin Google Authenticator atau Wordfence.

## 3. Batasi wp-admin

```apache
# .htaccess di /wordpress/wp-admin/
<Limit GET POST>
  Order Deny,Allow
  Deny from All
  Allow from 192.168.56.0/24
</Limit>
```

## 4. PHP Hardening

```ini
; /etc/php/7.x/apache2/php.ini
disable_functions = exec,passthru,shell_exec,system,proc_open,popen,curl_exec
expose_php = Off
```

## 5. Firewall

```bash
sudo ufw default deny incoming
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

## 6. Nonaktifkan Service Tidak Diperlukan

```bash
sudo systemctl disable dovecot    # Matikan POP3/IMAP jika bukan mail server
sudo systemctl stop dovecot
```

## Checklist

- [ ] WordPress diupdate ke versi terbaru
- [ ] Password WordPress diganti (kuat)
- [ ] Password root diganti
- [ ] File .root_password_ssh.txt dihapus
- [ ] DISALLOW_FILE_EDIT/MODS ditambahkan
- [ ] XML-RPC dinonaktifkan
- [ ] Directory listing uploads dinonaktifkan
- [ ] 2FA diaktifkan untuk admin
- [ ] UFW firewall aktif
- [ ] Service tidak diperlukan dinonaktifkan

# 02 — Web Enumeration (dirb + WPScan)

## dirb — Directory Crawling

```bash
dirb http://192.168.56.103/
```

### Temuan Penting:
```
+ /index.html         (CODE:200|SIZE:10821)
+ /info.php           (CODE:200|SIZE:83014)    ← phpinfo() exposed!
+ /server-status      (CODE:403)
==> DIRECTORY: /wordpress/
  ==> /wordpress/wp-admin/
  ==> /wordpress/wp-content/
  ==> /wordpress/wp-includes/
  + /wordpress/xmlrpc.php  (CODE:405)          ← XML-RPC aktif
  + /wordpress/wp-admin/admin.php (CODE:302)
```

**Temuan kritis:** `/info.php` mengekspos phpinfo() yang berisi informasi server, PHP config, environment variables, dan paths.

---

## WPScan — WordPress Enumeration

```bash
wpscan --url http://192.168.56.103/wordpress/ -e at -e ap -e u
```

**Flag `-e` (enumerate):**
| Flag | Keterangan |
|------|-----------|
| `at` | All Themes |
| `ap` | All Plugins |
| `u` | Users |

### Interesting Findings:

**WordPress Version:**
```
[+] WordPress version 5.2.4 identified (Insecure, released on 2019-10-14)
```

**Theme:**
```
[+] WordPress theme: twentynineteen
    Version: 1.4 (out of date, latest: 3.1)
```

**XML-RPC:**
```
[+] XML-RPC seems to be enabled: http://192.168.56.103/wordpress/xmlrpc.php
    Confidence: 100%
```

**Upload Directory Listing:**
```
[+] Upload directory has listing enabled: /wordpress/wp-content/uploads/
    Confidence: 100%
```

**WP-Cron:**
```
[+] External WP-Cron enabled: /wordpress/wp-cron.php
```

**User Enumeration:**
```
[i] User(s) Identified:

[+] c0rrupt3d_brain
    Found By: Author Posts – Author Pattern (Passive Detection)
    Confirmed By:
    | Rss Generator (Passive Detection)
    | Wp Json Api (Aggressive Detection)
    |   - http://192.168.56.103/wordpress/index.php/wp-json/wp/v2/users/...
    | Author Id Brute Forcing (Aggressive Detection)
    | Login Error Messages (Aggressive Detection)
```

**Username ditemukan: `c0rrupt3d_brain`**

---

## Key Takeaways

- WordPress 5.2.4 sudah usang dan vulnerable
- XML-RPC aktif → dapat dipakai untuk amplifikasi brute-force
- Upload directory listing → eksposur file
- User c0rrupt3d_brain teridentifikasi → target brute-force

---
*Next: [03-exploitation.md](03-exploitation.md)*

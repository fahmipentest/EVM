[01-recon.md](https://github.com/user-attachments/files/26491942/01-recon.md)
# 01 — Reconnaissance

## Nmap Aggressive Scan

```bash
nmap -A -p- 192.168.56.103
```

### Hasil:
```
PORT    STATE  SERVICE    VERSION
22/tcp  open   ssh        OpenSSH 7.2p2 Ubuntu 4ubuntu2.2
53/tcp  open   domain     ISC BIND 9.10.3-P4
80/tcp  open   http       Apache httpd 2.4.18 ((Ubuntu))
         |_http-title: Apache2 Ubuntu Default Page: It works
110/tcp open   pop3       Dovecot pop3d
139/tcp open   netbios-ssn Samba smbd 3.X – 4.X
143/tcp open   imap       Dovecot imapd
445/tcp open   netbios-ssn Samba smbd 4.3.11-Ubuntu

OS: Linux 3.2 – 4.14
Hostname: ubuntu-extermely-vulnerable-m4ch1ine
MAC: 08:00:27:B2:5D:5A (Oracle VirtualBox)
SMB: account_used=guest, message_signing=disabled (dangerous, but default)
```

---

## Nessus Vulnerability Scan

Nessus memberikan hasil lebih detail dengan 33 kerentanan:

| Severity | Count | Keterangan |
|----------|-------|-----------|
| Critical | 1 | CVSS 10.0 — General |
| Mixed | 2 | OpMisc, SMMisc |
| Low | 1 | ICMP — CVSS 2.1 |
| Info | 29 | SMWindows, DADNS, HTWeb, ApWeb, dll |

**Keunggulan Nessus vs Nmap:**
- Mendeteksi CVE secara spesifik
- Plugin-based scanning lebih dalam
- Report lebih terstruktur untuk enterprise
- Dapat mendeteksi misconfig yang tidak terlihat di Nmap

---

## Analisis Attack Surface

| Port | Service | Prioritas |
|------|---------|-----------|
| 80 | Apache + WordPress | ⭐ Tinggi — web exploitation |
| 22 | SSH | Menengah — setelah dapat credential |
| 139/445 | Samba | Rendah — SMB enumeration |
| 110/143 | POP3/IMAP | Rendah — tidak dieksploitasi |

**Prioritas:** Port 80 → WordPress enumeration

---
*Next: [02-web-enum.md](02-web-enum.md)*

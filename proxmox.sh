#!/bin/bash

# Prüfen, ob apt und curl installiert sind, andernfalls installieren
echo "Überprüfe, ob 'apt' und 'curl' installiert sind..."
if ! command -v apt &> /dev/null; then
    echo "'apt' nicht gefunden. Installiere es..."
    apt update && apt install -y apt-transport-https
fi

if ! command -v curl &> /dev/null; then
    echo "'curl' nicht gefunden. Installiere es..."
    apt update && apt install -y curl
fi

# Plex Media Server installieren
echo "Plex Media Server wird installiert..."

# Plex Repository hinzufügen
curl https://downloads.plex.tv/plex-keys/plex.asc | apt-key add -
echo "deb https://downloads.plex.tv/repo/deb public main" > /etc/apt/sources.list.d/plex.list

# Paketquellen aktualisieren und Plex installieren
apt update
apt install -y plexmediaserver

# Plex starten
systemctl start plexmediaserver
systemctl enable plexmediaserver

# Plex Status überprüfen
systemctl status plexmediaserver

echo "Plex Media Server wurde erfolgreich installiert und gestartet."

# WireGuard installieren
echo "WireGuard wird installiert..."

# WireGuard installieren
apt update
apt install -y wireguard

# WireGuard Konfigurationsdatei erstellen
cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = IGVjuh4/7fzn3Eoo0biWXOGBXnG/whYbZgBixvpmhHc=
Address = 10.8.0.12/24
DNS = 1.1.1.1

[Peer]
PublicKey = JK/Yv1/A1CitI4mminm9gedpSToSPo1UFWG158knCRY=
PresharedKey = 2tOqAKcCXnQWgVlIxsFTqwqS/Avel5zbKOoEyD6LjeU=
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = 85.215.35.43:51820
EOF

# Berechtigungen für die Konfiguration setzen
chmod 600 /etc/wireguard/wg0.conf

# WireGuard aktivieren und starten
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0

# WireGuard Status überprüfen
systemctl status wg-quick@wg0

echo "WireGuard wurde erfolgreich installiert und gestartet."

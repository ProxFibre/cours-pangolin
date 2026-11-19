#!/bin/bash
# À lancer en root sur ta LXC de lab.
set -e

mkdir -p /opt/pangolin && cd /opt/pangolin
curl -fsSL https://static.pangolin.net/get-installer.sh | bash

IP=$(hostname -I | awk '{print $1}')

./installer --non-interactive --base-domain="lab.local" --dashboard-domain="$IP" \
  --letsencrypt-email="admin@lab.local" --ipv6=false --maxmind=false

echo
echo "=== Pangolin installé ==="
echo "Accès web : dans le dashboard ProxFibre, onglet 'Navigateur Web Lab', entrez :"
echo "  https://$IP:443"
echo
echo "Token de setup initial :"
docker logs pangolin 2>&1 | grep -A1 "SETUP TOKEN"

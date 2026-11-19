#!/bin/bash
# À lancer en root sur ta LXC de lab.
set -e

# Utilisateur admin non-root, plus propre que de tout faire en root.
if ! id -u proxuser >/dev/null 2>&1; then
  apt-get update -qq && apt-get install -y -qq sudo >/dev/null
  useradd -m -s /bin/bash -G sudo proxuser
  echo 'proxuser:ProxFibreLab2026!' | chpasswd
fi

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

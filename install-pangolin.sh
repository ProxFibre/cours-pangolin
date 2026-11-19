#!/bin/bash
# À lancer en root sur ta LXC de lab.
set -e

# Sans lsb-release, l'installeur écrit un dépôt Docker invalide et Docker n'est pas installé.
apt-get update -qq && apt-get install -y -qq lsb-release >/dev/null
curl -fsSL https://get.docker.com | sh

# Le template désactive l'auth par mot de passe SSH par défaut.
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh

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

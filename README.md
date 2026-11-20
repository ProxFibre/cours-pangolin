# Cours Pangolin : installation pas à pas

Chaque étape se fait dans la LXC qui t'a été attribuée.

Mot de passe root par défaut : `ProxFibreLab2026!`

## 1. Activer la connexion SSH root par mot de passe

Ouvre la console de ta LXC depuis la VNC de Proxmox, connecte-toi en `root`, puis :

```bash
nano /etc/ssh/sshd_config
```

- Cherche la ligne `PermitRootLogin prohibit-password`
- Retire le `#` au début si besoin, et remplace `prohibit-password` par `yes`
- Sauvegarde et quitte : `CTRL + X`, puis `Y`, puis `ENTRÉE`

Puis redémarre SSH :

```bash
systemctl restart ssh
```

## 2. Mettre à jour le système et installer curl

```bash
apt update
apt upgrade -y
apt install curl -y
```

## 3. Lancer le script d'installation de Pangolin

```bash
curl -fsSL https://raw.githubusercontent.com/ProxFibre/cours-pangolin/main/install-pangolin.sh | bash
```

Le script installe Docker puis Pangolin. À la fin, il affiche le token de setup : garde-le, il ne sert qu'une fois.

Ouvre ensuite `https://<IP de ta LXC>/auth/initial-setup` (l'IP est affichée à la fin du script), entre le token et crée ton compte admin. Le navigateur affichera un avertissement de certificat : accepte-le.

## 4. Rediriger le nom de ta ressource vers ta LXC

Une fois ta ressource créée dans Pangolin (par exemple `feur.lab.local`), ton ordinateur doit savoir où trouver ce nom. Ajoute une ligne dans son fichier hosts :

Sous Linux ou macOS :

```bash
echo "<IP de ta LXC> <sous-domaine>.lab.local" | sudo tee -a /etc/hosts
```

Sous Windows, ouvre `C:\Windows\System32\drivers\etc\hosts` en administrateur et ajoute la ligne :

```
<IP de ta LXC> <sous-domaine>.lab.local
```

Ensuite, ouvre `https://<sous-domaine>.lab.local` dans ton navigateur et accepte l'avertissement de certificat.

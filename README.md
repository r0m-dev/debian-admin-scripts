# debian-post-install
> Debian tunning after fresh install :sparkles:
```bash
apt update && apt full-upgrade -yy
```
Installation de git
```bash
apt install git -yy
```
Téléchargement du script
```bash
git clone https://github.com/rberbille/debian-post-install.git
```
Attribution des droits d'execution pour lancer le script
```bash
cd debian-post-install && chmod +x setup.sh
```
Lancement du script :rocket:
```bash
./setup.sh
```

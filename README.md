# Debian admin scripts
## Post-install script
> Debian tunning after fresh install :sparkles:
Téléchargement du script
```bash
apt-get install git -yy && git clone https://github.com/rberbille/debian-admin-scripts.git
```
Attribution des droits d'execution pour lancer le script
```bash
cd debian-admin-scripts && chmod +x post-install.sh
```
Lancement du script :rocket:
```bash
./post-install.sh
```
## PXE install script
> Installation d'un serveur PXE compatible Bios, EFI32 et EFI64

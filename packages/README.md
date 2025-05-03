# Installing packages

## Make a package list for *all* packages

pacman -Qqe > allpackages.txt

## Make a list of pacman only packages

pacman -Qqen > pacman.txt

## Make a list of AUR packages

pacman -Qqem > yay.txt

## Install from list

pacman -S --needed < pacman.txt

## Make a list of zap plugins for zsh

zap list | awk 'NR>2 {print $3}' > zaplist.txt

## Make a list of flatpak packages

flatpak list | awk -F '\t' '{print $2}' > flatpak.txt

## Install flatpak packages from list

flatpak update < flatpak.txt

# Pacman management tips

## Refresh mirrors

pacman -Syy

## Check cache size

du -sh /var/cache/pacman/pkg/

## Clear cache

sudo paccache -r

## Clear uninstalled packages

sudo paccache -ruk0
sudo pacman -Sc
sudo pacman -Scc

## Remove prackages and dependencies

sudo pacman -Rs <package_name>

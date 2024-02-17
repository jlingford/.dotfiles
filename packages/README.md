# Make a package list for *all* packages

pacman -Qqe > allpackages.txt

# Make a list of pacman only packages

pacman -Qqen > pacman.txt

# Make a list of AUR packages

pacman -Qqem > yay.txt

# Install from list

pacman -S --needed < pacman.txt

# Make a list of zap plugins for zsh

zap list | awk 'NR>2 {print $3}' > zaplist.txt

# Make a list of flatpak packages

flatpak list | awk -F '\t' '{print $1}' > flatpak.txt

# Install flatpak packages from list

flatpak update < flatpak.txt



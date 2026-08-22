# NOTE: commands are only examples. Change as needed

# Install packages

```bash
pacman -S --needed - < allpackages.txt
```

# Setup .ssh keys

```bash
mkdir -p ~/.ssh
ssh-keygen -t ed25519 -C "xps13"
# follow ssh-keygen prompts

# add key to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/KEYNAME
cat ~/.ssh/KEYNAME.pub

## copy and paste .pub key to Github
## (Settings --> Access --> SSH & GPG keys)

# check everything works
ssh -T git@github.com

# clone dotfiles
git clone git@github.com/DOTFILES_REPO
# clone scripts as a home "bin"
git clone git@github.com/SCRIPTS_REPO ~/bin
```

# Stow files

```bash
# need to remove default niri config first
rm ~/.config/niri/config.kdl

# stow
stow -d ~/.dotfiles -t ~ chimerarc
stow -d ~/.dotfiles -t ~ configthemeing
stow -d ~/.dotfiles -t ~ dunst
stow -d ~/.dotfiles -t ~ fuzzel
stow -d ~/.dotfiles -t ~ gitconfig
stow -d ~/.dotfiles -t ~ kanshi
stow -d ~/.dotfiles -t ~ kitty
stow -d ~/.dotfiles -t ~ LazyVim
stow -d ~/.dotfiles -t ~ niri
stow -d ~/.dotfiles -t ~ nvim
stow -d ~/.dotfiles -t ~ pymolrc
stow -d ~/.dotfiles -t ~ satty
stow -d ~/.dotfiles -t ~ shikane
stow -d ~/.dotfiles -t ~ starship
stow -d ~/.dotfiles -t ~ swaybg
stow -d ~/.dotfiles -t ~ tmux
stow -d ~/.dotfiles -t ~ vim
stow -d ~/.dotfiles -t ~ waybar
stow -d ~/.dotfiles -t ~ yazi
stow -d ~/.dotfiles -t ~ zsh
```

# Niri setup

```bash
# create a niri session
niri-session -l

# reboot machine

# waybar needs to be stopped to prevent two waybars from appearing
systemctl --user disable waybar
```

# Keyd setup

To remap the annoying Copilot key to be a CTRL key

```bash
sudo touch /etc/keyd/default.conf

sudo cat > /etc/keyd/default.conf << EOF
[ids]
*

[main]
f23+leftshift+leftmeta = layer(control)
EOF

sudo systemctl enable --now keyd
```

# Mullvad VPN

```bash
sudo systemctl enable --now mullvad-daemon.service
```

# Change max battery charge to 80%

```bash
sudo vim /etc/tlp.conf
# uncomment lines regarding battery life for 80% max charge, and start charging below 75%
# STOP_CHARGE_THRESH_BAT0=80
sudo systemctl restart tlp
```

# Install micromamba

```bash
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
# follow prompts
```

# Setup zsh

```bash
# set zsh as default shell
chsh -s $(which zsh)

# install antidote plugins
ZDOTDIR=$HOME/.zsh

git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.zsh/.antidote
source ~/.zsh/.antidote/antidote.zsh
antidote load
```

# Wallpaper

```bash
mkdir -p ~/Pictures/Wallpapers
wget -P ~/Pictures/Wallpapers https://github.com/orangci/walls-catppuccin-mocha/blob/master/dark-waves.jpg
```

# Brave catppuccin theme

1. Go to Extensions --> Manage extensions --> turn on 'Developer mode' (toggle button top right corner of screen)
2. Add Stylus to addons <https://chromewebstore.google.com/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne?hl=en-GB>
3. Add catppuccin mocha to addons <https://chromewebstore.google.com/detail/catppuccin-chrome-theme-m/bkkmolkhemgaeaeggcmfbghljjjoofoh?hl=en-GB>
4. Add catppuccin icons to addons <https://chromewebstore.google.com/detail/catppuccin-for-web-file-e/lnjaiaapbakfhlbjenjkhffcdpoompki?hl=en-GB>
5. Download catppuccin config for Stylus
    - see docs: <https://userstyles.catppuccin.com/getting-started/usage/>
    - download `import.json` <https://github.com/catppuccin/userstyles/releases/download/all-userstyles-export/import.json>
    - open Stylus Manage page
        - click on extensions icon on Brave
        - click on three dots icon to the right of Stylus icon
        - select Manage from dropdown menu
        - click 'Import' button (top of screen)
        - select import.json from Downloads folder
        - changes should be instant

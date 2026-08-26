# Installation of dotfiles and config

*NOTE: commands are only examples. Change as needed*

## Install packages

```bash
pacman -S --needed - < allpackages.txt
```

## Setup .ssh keys

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

## Stow files

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
stow -d ~/.dotfiles -t ~ mako
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

## Niri setup

```bash
# create a niri session
niri-session -l

# reboot machine

# waybar needs to be stopped to prevent two waybars from appearing
systemctl --user disable waybar
```

## Tmux setup

Need to install tpm plugin manager

```bash
# install tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# also need to manually install catppuccin-tmux
mkdir -p ~/.tmux/plugins/catppuccin
git clone -b v2.3.0 https://github.com/catppuccin/tmux.git ~/.tmux/plugins/catppuccin/tmux

# run tmux, install plugins
tmux
tmux source ~/.tmux.conf
# install plugins with 'ctrl-b + I'
```

## Keyd setup

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

## Mullvad VPN

```bash
sudo systemctl enable --now mullvad-daemon.service
```

## Install micromamba

```bash
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
# follow prompts

# then rename the micromamba binary to mamba, for ease of use
mv ~/.local/bin/micromamba ~/.local/bin/mamba
```

## Setup zsh

```bash
# set zsh as default shell
chsh -s $(which zsh)

# install antidote plugins
ZDOTDIR=$HOME/.zsh

git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.zsh/.antidote
source ~/.zsh/.antidote/antidote.zsh
antidote load
```

## Wallpaper

```bash
mkdir -p ~/Pictures/Wallpapers
wget -P ~/Pictures/Wallpapers https://github.com/orangci/walls-catppuccin-mocha/blob/master/dark-waves.jpg
```

## Brave catppuccin theme

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

## OpenSSH

Make sure openssh and ufw are installed

```bash
# run on host
sudo systemctl enable --now sshd

# find host ip addr
ip addr
# ip addr is under inet, ignore forward slash and everything after it

```

Make sure host has an authorized_keys file for ssh

```bash
# in host
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

In client, make a new ssh key, and copy public key to host authorized_keys

```bash
# in host
ssh-keygen -t ed25519 -f ~/.ssh/KEYNAME -C "INFO:EMAIL"
# follow prompts, add passphrase for better security

# either manually copy and paste public key to authorized_keys, or
ssh-add ~/.ssh/KEYNAME
ssh-copy-id -i ~/.ssh/KEYNAME user@ipaddr
```

Update sshd_config with better security to prevent port knocking

```bash
# backup original config file first
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# edit config file
sudo vim /etc/ssh/sshd_config

# And make changes
Port 4589 # make something that isn't port 22
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
AuthenticationMethods publickey # can only ssh with ssh keys
MaxAuthTries 3
AllowUsers <username> # restrict to specific username
AuthorizedKeysFile .ssh/authorized_keys

# check everything about the config is fine
sudo sshd -t
```

Enable firewall

```bash
# in host
sudo systemctl enable --now ufw

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow PORTNUMBER/tcp
sudo ufw enable

sudo ufw allow PORTNUMBER/tcp comment 'Open port ssh tcp port'
sudo ufw status
```

Ssh into host from client machine

```bash
# in client
ssh -p PORTNUMBER user@ipaddr
```

On client, install `fail2ban` for more security

```bash
paru -S fail2ban
```

## Tailscale

> [!WARNING]
> mullvad-daemon must be disabled for this to work, otherwise internet gets blocked

```bash
paru -S tailscale
sudo systemctl enable --now tailscaled
sudo tailscale up
# follow link to browser, follow setup
sudo tailscale set --ssh
# machine is now ssh accessible, see ip addr from tailscale dashboard

ssh username@tailscaleIPaddr
```

## Bluetooth

Make sure bluez is installed

```bash
paru -S bluez bluez-utils
sudo systemctl enable bluetooth.service
```

Can now open GUI bluetooth manager and connect devices

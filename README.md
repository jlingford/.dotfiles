# Creating symlinks with GNU Stow

Stow is a symbolic link manager. It allows the user to move all their dotfiles into one directory (which can be easily version controlled with Git),
while still having the dotfiles linked to their original directory.
So any program that needs to read that dotfile (i.e. the configuration file) can still read it were still in it's original location.

As an example, here's how to "stow" your `.zshrc` file.

```bash
# create the dotfiles dir with a sub-dir for zsh
mkdir -p ~/.dotfiles/zsh

# good idea to backup you .zshrc file first
cp ~/.zshrc ~/.backup/.zshrc.bak

# move the .zshrc to the stow folder
mv ~/.zshrc ~/.dotfiles/zsh

# create the symlink with stow
stow -d ~/.dotfiles -t ~ zsh 
```

An important thing to remember with stow is that the dotfile you are "stowing" must be contained within a directory structure that exactly matches that of the original directory structure.
For instance, your `.zshrc` dotfile is housed within the `~/.dotfiles/zsh` directory, where the `/zsh` dir resembles your home dir.
But if a dotfile is contained in further subdirectories away from your home dir, then these subdirectories must be included in the `~/.dotfiles` structure.
It's easier to explain with an example.
Say you want to "stow" your `keymaps.lua` config file for your neovim setup, the setup would look like so:

```bash
# create a new stow dir called "neovim" that also contains a dir structure that mirrors the real neovim dir structure
mkdir -p ~/.dotfiles/neovim/.config/nvim/lua/config

# backup your config file of interest
cp ~/.config/nvim/lua/config/keymaps.lua ~/.backup/keymaps.lua.bak

# move your config file to the stow folder
mv ~/.config/nvim/lua/config/keymaps.lua ~/.dotfiles/neovim/.config/nvim/lua/config

# create the symlink
stow -d ~/.dotfiles -t ~ neovim
```

A useful mental trick that [Christian Chiarulli](https://www.chrisatmachine.com/) has is to pretend that, once you are inside your `~/.dotfiles/<DIR_NAME>` of interest, pretend that this is now your home dir.
So if you were to navigate to your neovim config files from your home dir, you would `cd .config/nvim/lua/config` to get to your config file of interest.
This is essentially how the GNU stow program sees things too, so the directory structures must follow this pattern for the program to create the symlinks in their proper locations.

TODO - move yazi config to zsh dir
TODO - move starship toml to zsh dir
TODO - move picom config to new stow dir

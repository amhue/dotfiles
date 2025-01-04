#!/usr/bin/sh 

set -xe

ln -sf $(pwd)/alacritty ~/.config/
ln -sf $(pwd)/i3status ~/.config/
sudo ln -sf $(pwd)/ly /etc/
ln -sf $(pwd)/mako ~/.config/
ln -sf $(pwd)/nvim ~/.config/
ln -sf $(pwd)/spicetify ~/.config/
ln -sf $(pwd)/sway ~/.config/

ln -sf $(pwd)/.emacs ~/
ln -sf $(pwd)/.zshrc ~/
ln -sf $(pwd)/.gitconfig ~/

# yay -Syu
yay -S $(cat intalled)

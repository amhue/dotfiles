#!/usr/bin/sh

set -xe

ln -sf $(pwd)/alacritty ~/.config/;
ln -sf $(pwd)/i3status ~/.config/;
# sudo ln -sf $(pwd)/ly /etc/;
ln -sf $(pwd)/mako ~/.config/;
ln -sf $(pwd)/nvim ~/.config/;
ln -sf $(pwd)/sway ~/.config/;

ln -sf $(pwd)/.emacs ~/;
ln -sf $(pwd)/.zshrc ~/;
ln -sf $(pwd)/.gitconfig ~/;

ln -sf $(pwd)/splash-text ~/

ln -sf $(pwd)/eww ~/.config/eww;
ln -sf $(pwd)/waybar ~/.config/waybar;

mkdir -p ~/.emacs.d/lisp;
ln -sf $(pwd)/projects.el ~/.emacs.d/lisp/projects.el;

# yay -Syu
yay -S $(cat installed);
sudo ln -sf $(pwd)/.emacsc /usr/bin/;

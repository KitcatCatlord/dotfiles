#!/usr/bin/env bash
set -e
sudo apt update
if ! command -v nvim &> /dev/null; then
  sudo apt install -y neovim
fi
if ! command -v dotnet &> /dev/null; then
  sudo apt install -y dotnet-sdk-8.0
fi
if ! command -v git &> /dev/null; then
  sudo apt install -y git
fi
cd ~
if [ ! -d "~/dotfiles" ]; then
  git clone https://github.com/KitcatCatlord/dotfiles.git ~/dotfiles
fi
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/alacritty ~/.config/alacritty
nvim --headless "+Lazy! sync" +qa
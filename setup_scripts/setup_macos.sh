#!/usr/bin/env bash
set -e
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if ! command -v nvim &> /dev/null; then
  brew install neovim
fi
if ! command -v dotnet &> /dev/null; then
  brew install --cask dotnet-sdk
fi
cd ~
if [ ! -d "~/dotfiles" ]; then
  git clone https://github.com/KitcatCatlord/dotfiles.git ~/dotfiles
fi
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/alacritty ~/.config/alacritty
nvim --headless "+Lazy! sync" +qa
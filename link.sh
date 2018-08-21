#! /usr/bin/env bash

ln -sf ~/dotfiles/src/vimrc ~/.vimrc
ln -sf ~/dotfiles/src/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/src/vimrc.bundles ~/.vimrc.bundles
ln -sf ~/dotfiles/src/aliases ~/.aliases
ln -sf ~/dotfiles/src/bashrc ~/.bashrc
ln -sf ~/dotfiles/src/bash_profile ~/.bash_profile
ln -sf ~/dotfiles/src/bash_secrets ~/.bash_secrets
ln -sf ~/dotfiles/src/eslintrc ~/.eslintrc
ln -sf ~/dotfiles/src/ctags ~/.ctags

mkdir -p ~/.config/nvim/
ln -sf ~/dotfiles/src/init.vim ~/.config/nvim/init.vim

ln -sf ~/dotfiles/src/gitconfig-work ~/.gitconfig-work
ln -sf ~/dotfiles/src/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/src/gitignore ~/.gitignore
ln -sf ~/dotfiles/src/gitignore ~/.ignore

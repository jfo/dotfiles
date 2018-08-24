WD=$(shell pwd)

link: nvimrc
	ln -sf $(WD)/dots/vimrc ~/.vimrc
	ln -sf $(WD)/dots/tmux.conf ~/.tmux.conf
	ln -sf $(WD)/dots/bashrc ~/.bashrc
	ln -sf $(WD)/dots/bash_profile ~/.bash_profile
	ln -sf $(WD)/dots/bash_secrets ~/.bash_secrets
	ln -sf $(WD)/dots/gitconfig-work ~/.gitconfig-work
	ln -sf $(WD)/dots/gitconfig ~/.gitconfig
	ln -sf $(WD)/dots/gitignore ~/.gitignore
	ln -sf $(WD)/dots/eslintrc ~/.eslintrc

nvimrc:
	mkdir -p ~/.config/nvim/
	ln -sf $(WD)/src/init.vim ~/.config/nvim/init.vim

plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +'PlugInstall --sync' +qa
	vim +'UpdateRemotePlugins' +qa
	mkdir -p ~/.vim/colors
	cp ~/.vim/plugged/vim-colors-solarized/colors/solarized.vim ~/.vim/colors

last:
	mkdir -p ~/.vim/sessions/
	touch ~/.vim/sessions/last.vim

all: link plug last


clean:
	rm -rf ~/.vimrc ~/.tmux.conf ~/.bashrc ~/.bash_profile ~/.bash_secrets ~/.gitconfig-work ~/.gitconfig ~/.gitignore ~/.vim ~/.config ~/code/zig/default.nix

# nix ish
nix:
	sudo cp ./nix/configuration.nix /etc/nixos/
	sudo nixos-rebuild switch

zig:
	ln -sf $(WD)/nix/zig-dev.nix ~/code/zig/default.nix


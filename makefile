WD=$(shell pwd)

link:
	ln -sf $(WD)/src/vimrc ~/.vimrc
	ln -sf $(WD)/src/tmux.conf ~/.tmux.conf
	ln -sf $(WD)/src/bashrc ~/.bashrc
	ln -sf $(WD)/src/bash_profile ~/.bash_profile
	ln -sf $(WD)/src/bash_secrets ~/.bash_secrets
	mkdir -p ~/.config/nvim/
	ln -sf $(WD)/src/init.vim ~/.config/nvim/init.vim
	ln -sf $(WD)/src/gitconfig-work ~/.gitconfig-work
	ln -sf $(WD)/src/gitconfig ~/.gitconfig
	ln -sf $(WD)/src/gitignore ~/.gitignore

nix:
	sudo cp ./configuration.nix /etc/nixos/
	sudo nixos-rebuild switch

plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +'PlugInstall --sync' +qa
	mkdir -p ~/.vim/colors
	cp ~/.vim/plugged/vim-colors-solarized/colors/solarized.vim ~/.vim/colors

zig:
	ln -sf $(WD)/zig-dev.nix ~/code/zig/default.nix

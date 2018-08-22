WD=$(shell pwd)

default: plug

link:
	ln -sf $(WD)/src/vimrc ~/.vimrc
	ln -sf $(WD)/src/tmux.conf ~/.tmux.conf
	ln -sf $(WD)/src/bashrc ~/.bashrc
	ln -sf $(WD)/src/bash_profile ~/.bash_profile
	ln -sf $(WD)/src/bash_secrets ~/.bash_secrets
	ln -sf $(WD)/src/gitconfig-work ~/.gitconfig-work
	ln -sf $(WD)/src/gitconfig ~/.gitconfig
	ln -sf $(WD)/src/gitignore ~/.gitignore

plug: link
	mkdir -p ~/.config/nvim/
	mkdir -p ~/.vim/colors
	ln -sf $(WD)/src/init.vim ~/.config/nvim/init.vim
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +'PlugInstall --sync' +qa
	cp ~/.vim/plugged/vim-colors-solarized/colors/solarized.vim ~/.vim/colors


nix:
	sudo cp ./nix/configuration.nix /etc/nixos/
	sudo nixos-rebuild switch

zig:
	ln -sf $(WD)/nix/zig-dev.nix ~/code/zig/default.nix

clean:
	rm -rf ~/.vimrc ~/.tmux.conf ~/.bashrc ~/.bash_profile ~/.bash_secrets ~/.gitconfig-work ~/.gitconfig ~/.gitignore ~/.vim ~/.config ~/code/zig/default.nix

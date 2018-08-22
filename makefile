WD=$(shell pwd)

link:
	ln -sf $(WD)/dots/vimrc ~/.vimrc
	ln -sf $(WD)/dots/tmux.conf ~/.tmux.conf
	ln -sf $(WD)/dots/bashrc ~/.bashrc
	ln -sf $(WD)/dots/bash_profile ~/.bash_profile
	ln -sf $(WD)/dots/bash_secrets ~/.bash_secrets
	ln -sf $(WD)/dots/gitconfig-work ~/.gitconfig-work
	ln -sf $(WD)/dots/gitconfig ~/.gitconfig
	ln -sf $(WD)/dots/gitignore ~/.gitignore

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

WD=$(shell pwd)

all: link plug last

link: directories config
	ln -sf $(WD)/dots/vimrc ~/.vimrc
	ln -sf $(WD)/dots/tmux.conf ~/.tmux.conf
	ln -sf $(WD)/dots/gitconfig-work ~/.gitconfig-work
	ln -sf $(WD)/dots/gitconfig ~/.gitconfig
	ln -sf $(WD)/dots/gitignore ~/.gitignore
	ln -sf $(WD)/dots/eslintrc.js ~/.eslintrc.js
	ln -sf $(WD)/dots/npmrc ~/.npmrc

config:
	ln -sf $(WD)/config/nvim/init.vim ~/.config/nvim/init.vim
	ln -sf $(WD)/config/fish ~/.config/fish

directories:
	mkdir -p ~/.config/nvim/
	mkdir -p ~/.config/fish/
	mkdir -p ~/.vim/tmp/
	mkdir -p ~/.vim/sessions/
	mkdir -p ~/.vim/colors/

plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +'PlugInstall --sync' +qa
	nvim +'UpdateRemotePlugins' +qa
	cp ~/.vim/plugged/vim-colors-solarized/colors/solarized.vim ~/.vim/colors

last:
	touch ~/.vim/sessions/last.vim

clean:
	rm -rf ~/.vimrc ~/.tmux.conf ~/.bashrc ~/.bash_profile ~/.bash_secrets.sh ~/.gitconfig-work ~/.gitconfig ~/.gitignore ~/.vim ~/.config ~/code/zig/default.nix

# nix ish
nix:
	sudo cp ./nix/configuration.nix /etc/nixos/
	sudo nixos-rebuild switch

zig:
	ln -sf $(WD)/nix/zig-dev.nix ~/code/zig/default.nix

.PHONY: nix zig clean all

WD=$(shell pwd)

all: stow plug last

stow:
	stow --dotfiles --no-folding --target=${HOME} dots

clean:
	stow -D --target=${HOME} dots

directories:
	mkdir -p ~/.vim/tmp/
	mkdir -p ~/.vim/sessions/
	mkdir -p ~/.vim/colors/

plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +'PlugInstall --sync' +qa
	nvim +'UpdateRemotePlugins' +qa
	cp ~/.vim/plugged/vim-colors-solarized/colors/solarized.vim ~/.vim/colors

last:
	mkdir -p ~/.vim/sessions && touch ~/.vim/sessions/last.vim

# nix ish
nix:
	sudo cp ./nix/configuration.nix /etc/nixos/
	sudo nixos-rebuild switch

zig:
	ln -sf $(WD)/nix/zig-dev.nix ~/code/zig/default.nix

.PHONY: nix zig clean all

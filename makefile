WD=$(shell pwd)

all: stow plug last

stow:
	stow --dotfiles --no-folding --target=${HOME} dots

clean:
	stow -D --dotfiles --target=${HOME} dots

plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +'PlugInstall --sync' +qa
	nvim +'UpdateRemotePlugins' +qa

last:
	mkdir -p ~/.vim/sessions && touch ~/.vim/sessions/last.vim

# nix ish
nix:
	sudo cp ./nix/configuration.nix /etc/nixos/
	sudo nixos-rebuild switch

zig:
	ln -sf $(WD)/nix/zig-dev.nix ~/code/zig/default.nix

.PHONY: nix zig clean all

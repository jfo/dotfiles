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

.PHONY: nix zig clean all

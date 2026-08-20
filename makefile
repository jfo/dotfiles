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

bootstrap:
	./bootstrap.sh

macos:
	./macos.sh

brewfile:
	brew bundle dump --file=Brewfile.new --describe --force
	@echo "wrote Brewfile.new -- diff it against Brewfile before replacing"

claude-app:
	@sed '/claude-code-only below this line/,$$d' dots/.claude/CLAUDE.md | pbcopy
	@echo "Copied. Paste into claude.ai -> Settings -> Profile."

.PHONY: all stow clean plug last bootstrap macos claude-app

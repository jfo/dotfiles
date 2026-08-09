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

# Copy the app-portable half of CLAUDE.md (everything above the
# claude-code-only marker) to the clipboard, for pasting into
# claude.ai -> Settings -> Profile. There is no automatic sync.
claude-app:
	@sed '/claude-code-only below this line/,$$d' dots/.claude/CLAUDE.md | pbcopy
	@echo "Copied. Paste into claude.ai -> Settings -> Profile."

.PHONY: all stow clean plug last claude-app

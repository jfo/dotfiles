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

# Full fresh-machine setup. See bootstrap.sh for the individual steps.
bootstrap:
	./bootstrap.sh

# macOS system defaults (key repeat, dock, hot corners, finder...).
macos:
	./macos.sh

# Regenerate the Brewfile from what is currently installed.
# Check the diff: `brew bundle dump` has been observed to silently drop
# tapped formulae (k9s, ddev, astroterm), so do not blind-commit this.
brewfile:
	brew bundle dump --file=Brewfile.new --describe --force
	@echo "wrote Brewfile.new -- diff it against Brewfile before replacing"

# RUN THIS ON THE OLD MACHINE. Pulls live config that was never tracked
# into the repo so it survives the move.
adopt:
	mkdir -p dots/.config/fish/functions
	@for f in ~/.config/fish/functions/*.fish; do \
		[ -L "$$f" ] && continue; \
		cp -v "$$f" dots/.config/fish/functions/; \
	done
	@if [ -f ~/.ssh/config ]; then \
		mkdir -p dots/dot-ssh; \
		cp -v ~/.ssh/config dots/dot-ssh/config; \
		echo "NOTE: check dots/dot-ssh/config for anything secret before committing"; \
	fi
	@echo ""
	@echo "Adopted. Re-run 'make stow' so the live files become symlinks into the repo."
	@git status --short

# Copy the app-portable half of CLAUDE.md (everything above the
# claude-code-only marker) to the clipboard, for pasting into
# claude.ai -> Settings -> Profile. There is no automatic sync.
claude-app:
	@sed '/claude-code-only below this line/,$$d' dots/.claude/CLAUDE.md | pbcopy
	@echo "Copied. Paste into claude.ai -> Settings -> Profile."

.PHONY: all stow clean plug last bootstrap macos brewfile adopt claude-app

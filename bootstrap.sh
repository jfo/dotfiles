#!/usr/bin/env bash
# Everything that has to happen on a fresh machine that `stow` alone does not do.
# Idempotent: safe to re-run, skips what is already there.
#
#   ./bootstrap.sh          full run
#   ./bootstrap.sh brew     just one step (see STEPS below)
set -uo pipefail
cd "$(dirname "$0")"

STEPS=(brew shell stow vim tmux node erlang rust llm go cargo npm checks)
have() { command -v "$1" >/dev/null 2>&1; }
step() { echo ""; echo "==================== $1"; }

step_brew() {
  if ! have brew; then
    echo "!! Homebrew missing. Install it first:"
    echo '   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    return 1
  fi
  brew bundle install --file=Brewfile
  echo "-- sanity: things in Brewfile that did not land"
  comm -13 <(brew list --formula | sort) \
           <(grep -oE '^brew "[^"]+"' Brewfile | sed 's/brew "//;s/"//' | sed 's|.*/||' | sort) || true
}

step_shell() {
  local fish=/opt/homebrew/bin/fish
  [ -x "$fish" ] || { echo "!! $fish not found, run the brew step first"; return 1; }
  grep -qxF "$fish" /etc/shells || echo "$fish" | sudo tee -a /etc/shells >/dev/null
  [ "$SHELL" = "$fish" ] || chsh -s "$fish"
  echo "login shell: $(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')"
}

step_stow() {
  make stow
  echo "-- stowed:"
  find "$HOME" -maxdepth 4 -type l -lname '*dotfiles*' 2>/dev/null | sed "s|$HOME/|  ~/|"
  if [ ! -f "$HOME/.config/fish/secrets.fish" ]; then
    echo ""
    echo "!! ~/.config/fish/secrets.fish is missing (gitignored, by design)."
    echo "   Restore it from 1Password. It needs:"
    echo "     set -gx ADVENT_OF_CODE_TOKEN ..."
    echo "     set -gx CLAUDE_API_KEY ..."
    echo "     set -gx OBSIDIAN_VAULT_PATH ..."
  fi
  if [ ! -f "$HOME/.ssh/config" ]; then
    echo ""
    echo "!! ~/.ssh/config is missing. Hosts the old machine had:"
    echo "     *  |  *.public *.ext *.aws *.ibm *.onomondo.io  |  github.com"
    echo "     codeberg.org  |  dingus -> dingus.local"
  fi
}

step_vim() {
  make plug last
}

step_tmux() {
  local tpm="$HOME/.config/tmux/plugins/tpm"
  [ -d "$tpm" ] || git clone https://github.com/tmux-plugins/tpm "$tpm"
  echo "-- now start tmux and hit <prefix>+I to install plugins"
}

step_node() {
  have fnm || { echo "!! fnm missing"; return 1; }
  # The old machine had 33 versions installed. Two is plenty.
  fnm install 25.6.1
  fnm default 25.6.1
  fnm install --lts
  echo "-- node $(fnm exec --using=25.6.1 node -v)"
}

step_erlang() {
  have asdf || { echo "!! asdf missing"; return 1; }
  # .tool-versions is stowed to ~ and pins erlang / java / rebar
  for p in erlang java rebar; do asdf plugin add "$p" 2>/dev/null || true; done
  asdf install
  # installed on the old machine but never recorded in .tool-versions:
  #   opencode 1.2.6, python 3.14.4  -- add them here if you still want them
  asdf current
}

step_rust() {
  have rustup || { echo "!! rustup missing"; return 1; }
  rustup default stable
}

step_llm() {
  have llm || { echo "!! llm missing"; return 1; }
  llm install llm-anthropic llm-cmd
  llm models default anthropic/claude-opus-4-0
  echo "-- now run: llm keys set anthropic"
}

step_go()    { have go || return 1
               go install github.com/unknwon/bra@latest
               go install github.com/evilmartians/lefthook@latest; }

step_cargo() { have cargo || return 1; cargo install bpf-linker; }

step_npm()   { have npm || return 1; npm install -g onomondo-live; }

step_checks() {
  echo "-- git identity"
  echo "   ~/code:        $(git -C "$HOME/code" config user.email 2>/dev/null || echo '(no repo yet)')"
  echo "   ~/development: $(cd "$HOME/development" 2>/dev/null && git config user.email 2>/dev/null || echo '(no repo yet)')"
  echo "   (expect jeffowler@gmail.com and jf@onomondo.com -- includeIf on gitdir:~/development/)"
  echo "-- github"
  ssh -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 | head -1
  echo "-- aws";  have aws && (aws sts get-caller-identity 2>&1 | head -3)
  echo "-- kube"; have kubectl && (kubectl config get-contexts 2>&1 | head -5)
  echo ""
  echo "Still to do by hand:"
  echo "  gh auth login"
  echo "  aws configure sso            (sso-session jfo-ono)"
  echo "  aws eks update-kubeconfig --name staging-esim-iot-euc1 --region eu-central-1"
  echo "  ./macos.sh                   (system defaults)"
  echo "  fish_config                  (informative vcs prompt + fzf key bindings)"
  echo "  restore the Obsidian vault, then check <leader>D in nvim"
}

if [ $# -gt 0 ]; then
  for s in "$@"; do step "$s"; "step_$s"; done
else
  for s in "${STEPS[@]}"; do step "$s"; "step_$s" || echo "!! step '$s' failed, continuing"; done
fi

echo ""
echo "==================== done"

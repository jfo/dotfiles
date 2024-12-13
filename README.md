# Dotfiles for days

mostly for mac setup atm

* stow
* ghostty
* neovim
* tmux
* fish
* git

TODO
----
- better support for contexts, more than just gitconf
- make fish prompt better
- modernize vim config and packages being used
  - snippets
  - omnicomplete
  - linting / prettier / zig fmt, etc

```
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
```

Programs
---------
- Table plus
- Rectangle
- ghostty
- One password
- Slack
- Browsers
    - Firefox
    - Chrome
    - 1password plugin on everything
- Brew
    - Git
    - Fnm
        - Node (derr)
    - Nvim
    - Fish
    - Tmux
    - Stow
    - Ripgrep (rg)
    - Gh
    - parallel
    - awscli
    - jq
- Docker desktop

Setup to doooooo
- Rm all stuff from toolbar
- Autohide toolbar
- Remap caps to ctrl
- Set up external keyboard
- Setup bluetooth mouse
- Key repeat speed pls
- Invert scroll on touchpad
- Hot corners
- All updates
- Switch to fish


originally based on [maximum awesome](https://developer.squareup.com/blog/fly-vim-first-class/), so many
changes since then.


didn't need the fish functions folder in here, must run `fish_config` for the informative vcs prompt and fzf setup for fish shell bindings.

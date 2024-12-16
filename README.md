# Dotfiles for days

```
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
```

Programs
---------
- Table plus
- Rectangle (?)
- Ghostty
- 1Password
- Slack
- Browsers
    - Firefox
    - Chrome
    - 1password plugin on everything
- Brew
    - git
    - fnm
        - node (derr)
    - nvim
    - fish
    - tmux
    - stow
    - rg
    - hh
    - parallel
    - awscli
    - jq
    - bat
    - font-hack (for ghostty)
    - wireshark
    - llm
        - llm install llm-cmd
        - llm install llm-claude-3 
            - llm keys set claude
        - llm models default claude-3.5-[sonnet|haiku]
        - TODO: [get local models running](https://youtu.be/QUXQNi6jQ30?t=794&si=OABy0nFma2DGeCgH)
    - treesitter-cli
- Docker desktop

Setup to doooooo
- Rm all stuff from toolbar
- Remap caps to ctrl (won't need to do this if the firmware does it for me)
- Setup bluetooth mouse
- Key repeat speed pls
- Invert scroll on touchpad
- Hot corners
- All updates

Originally based on [maximum awesome](https://developer.squareup.com/blog/fly-vim-first-class/), so many
changes since then.


Didn't need the fish functions folder in here, must run `fish_config` for the informative vcs prompt and fzf setup for fish shell bindings.

TODO
----
- better support for contexts, more than just gitconf
- make fish prompt better
- modernize vim config and packages being used
  - snippets
  - omnicomplete
  - linting / prettier / zig fmt, etc
- [zvm](https://github.com/tristanisham/zvm) or similar for zig versioning...

- maybe something like [this for brew](https://matthiasportzel.com/brewfile/)

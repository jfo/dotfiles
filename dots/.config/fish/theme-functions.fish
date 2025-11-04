# Fish functions for unified theme switching
# Source this file in your fish config

function get_macos_appearance
    if test (uname) = "Darwin"
        set appearance (defaults read -g AppleInterfaceStyle 2>/dev/null)
        if test "$appearance" = "Dark"
            echo "dark"
        else
            echo "light"
        end
    else
        echo "light"  # Default for non-macOS
    end
end

function get_current_theme
    # Check for manual override first
    if set -q THEME_MODE
        echo $THEME_MODE
    else
        # Fall back to system appearance
        get_macos_appearance
    end
end

function set_ghostty_theme
    set mode $argv[1]
    set config_file "$HOME/.config/ghostty/config"

    # Resolve symlink to get the actual file path
    set real_config (readlink "$config_file" 2>/dev/null; or echo "$config_file")

    if test "$mode" = "dark"
        sed -i.bak 's/^theme = .*/theme = Gruvbox Dark Hard/' "$real_config"
    else
        sed -i.bak 's/^theme = .*/theme = Gruvbox Light Hard/' "$real_config"
    end

    # Reload config in all running Ghostty instances using cmd+shift+,
    if test (uname) = "Darwin"
        osascript -e 'tell application "System Events" to tell process "ghostty" to keystroke "," using {command down, shift down}' >/dev/null 2>&1; or true
    end
end

function set_tmux_theme
    set mode $argv[1]
    # Send command to all tmux sessions to update gruvbox theme
    if command -v tmux >/dev/null 2>&1; and tmux list-sessions >/dev/null 2>&1
        # Set the gruvbox mode option directly
        tmux set-option -g @tmux-gruvbox "$mode" 2>/dev/null; or true
        tmux set-environment -g TMUX_GRUVBOX_MODE "$mode"

        # Force reload the gruvbox plugin if it exists
        if test -f ~/.config/tmux/plugins/tmux-gruvbox/tmux-gruvbox.tmux
            tmux run-shell ~/.config/tmux/plugins/tmux-gruvbox/tmux-gruvbox.tmux 2>/dev/null; or true
        end

        # Also source the main config to pick up any other changes
        tmux source-file ~/.tmux.conf >/dev/null 2>&1; or true
    end
end

function notify_nvim
    set mode $argv[1]
    # Create a flag file that nvim can check (nvim auto-reloads on FocusGained)
    echo "$mode" > /tmp/nvim_theme_mode
end

function theme
    set target_mode $argv[1]
    
    switch "$target_mode"
        case "light" "dark"
            set -gx THEME_MODE "$target_mode"
        case "auto"
            set -e THEME_MODE
            set target_mode (get_current_theme)
        case "*"
            echo "Usage: theme [light|dark|auto]"
            return 1
    end
    
    echo "Switching to $target_mode mode..."

    # Update all applications
    set_ghostty_theme "$target_mode"
    set_tmux_theme "$target_mode"
    notify_nvim "$target_mode"

    echo "✓ Theme switched to $target_mode"
    echo "✓ Applied to all running Ghostty, tmux, and nvim instances"
end

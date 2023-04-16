fish_vi_key_bindings

set -g fish_autosuggestion_enabled 0
set fish_cursor_insert line blink

if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path ~/.yarn/bin

set -Ux EDITOR nvim


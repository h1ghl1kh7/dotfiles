# Clear fish greeting
set fish_greeting

# Set terminal colors
set -gx TERM xterm-256color

# Theme settings
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

set -gx EDITOR nvim
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0
set fish_key_bindings fish_user_key_bindings
set -gx GOROOT /usr/local/go

# Aliases
if command -qv lsd
  alias ls "lsd"
  alias la "lsd -A -l"
  alias ll "lsd -l -g"
end

alias ssh "ssh.exe"
alias ssh-add "ssh-add.exe"

alias e explorer.exe
alias g git
alias vim nvim
alias v nvim

# Path modifications
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.luarocks/bin
fish_add_path /usr/local/go/bin
fish_add_path /usr/bin


fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin
fish_add_path /usr/local/go/bin

fzf_configure_bindings --directory=\ef --git_log=\el --git_status=\es --processes=\ep

# pnpm
set -gx PNPM_HOME "/root/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

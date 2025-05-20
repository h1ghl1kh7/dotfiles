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

# Aliases
if command -qv lsd
  alias ls "lsd"
  alias la "lsd -A -l"
  alias ll "lsd -l -g"
end

alias vim nvim
alias v nvim

# Path modifications
fish_add_path $HOME/.local/bin
fish_add_path /usr/local/bin
fish_add_path $HOME/.luarocks/bin


switch (uname)
  case Darwin

# Homebrew setup
    eval "$(/opt/homebrew/bin/brew shellenv)"
    fish_add_path /usr/local/opt/binutils/bin

# Ruby setup
    fish_add_path /opt/homebrew/opt/ruby/bin
    status --is-interactive; and rbenv init - fish | source

# Additional PATH modifications
    fish_add_path /usr/local/opt/gnu-sed/libexec/gnubin

end

fzf_configure_bindings --directory=\ef --git_log=\el --git_status=\es --processes=\ep

# pnpm
set -gx PNPM_HOME "/Users/hyilim/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

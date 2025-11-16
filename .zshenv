export EDITOR="nvim"
export BROWSER="zen-browser"
export MUSICPLAYER="com.mastermindzh.tidal-hifi"
export TERMINAL="kitty"
export ARCH_CONFIG_DIR="${HOME}/.config/rybelika"

# Alias

# system
alias l='eza -lh  --icons=auto' # long list
alias lg='eza -lh  --icons=auto --grid' # long list grid
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias lga='eza -lha --icons=auto --sort=name --group-directories-first --grid' # long list all grid
alias ld='eza -lhD --icons=auto' # long list dirs

alias noctalia-shell='qs -c noctalia-shell'

# kitty
alias icat="kitten icat"
alias cp="cp -v"
alias mv="mv -v"

# apps
alias v='nvim'
alias cat='bat'

# obsidian
alias on="python3 ~/.local/bin/obsidian.py -n"
alias os="python3 ~/.local/bin/obsidian.py -s"
alias op="python3 ~/.local/bin/obsidian.py -p"

# game
alias turbo_on='sudo cpupower frequency-set -g performance'
alias turbo_off='sudo cpupower frequency-set -g powersave'
. "$HOME/.rokit/env"

# xampp
alias xampp-server='sudo /opt/lampp/lampp'
alias xampp-db='sudo /opt/lampp/bin/mariadb'

export ZSH="$HOME/.oh-my-zsh"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANPAGER="less -R --use-color -Dd+r -Du+b"

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"

# pnpm
export PNPM_HOME="/home/ryfenri/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

setopt EXTENDED_GLOB
unsetopt hist_verify

function push_obsidian() {
	current_date=$(date '+%d/%m/%Y %I:%M:%S')

	cd ~/personal || return 1

	git add . && \
	git commit -m "vault: $current_date" && \
	git push 

	cd -
}

function pull_obsidian() {
	cd ~/personal || return 1
	git pull
	cd -
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# global
alias -g C='| wl-copy'

# system
alias l='eza -lh  --icons=auto' # long list
alias lg='eza -lh  --icons=auto --grid' # long list grid
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias lga='eza -lha --icons=auto --sort=name --group-directories-first --grid' # long list all grid
alias ld='eza -lhD --icons=auto' # long list dirs
alias cp='cp -v'
alias mv='mv -v'

# kitty
alias icat="kitten icat"

# apps
alias v='nvim'
alias cat='bat'
alias noctalia-shell='qs -c noctalia-shell'

# obsidian
alias on="python3 ~/.local/bin/obsidian.py -n"
alias os="python3 ~/.local/bin/obsidian.py -s"
alias op="python3 ~/.local/bin/obsidian.py -p"

alias obps=push_obsidian
alias obpl=pull_obsidian

fastfetch

export PATH=$PATH:/home/ryfenri/.spicetify

# opencode
export PATH=/home/ryfenri/.opencode/bin:$PATH

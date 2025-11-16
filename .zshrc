export ZSH="$HOME/.oh-my-zsh"
export PATH="/home/ryfenri/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/ryfenri/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANPAGER="less -R --use-color -Dd+r -Du+b"

plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source $HOME/.zshenv

eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"

setopt EXTENDED_GLOB
unsetopt hist_verify

fastfetch

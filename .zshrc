export ZSH="$HOME/.oh-my-zsh"
export PATH="/home/ryfenri/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/ryfenri/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source $HOME/.zshenv

eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"

fastfetch

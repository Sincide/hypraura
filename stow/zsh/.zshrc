export ZDOTDIR="$HOME/.config/zsh"
autoload -U compinit && compinit
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true
PROMPT='%F{cyan}%n%f %F{yellow}%~%f %# '

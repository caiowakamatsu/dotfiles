# ~/.zshrc

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt autocd
setopt correct
setopt extendedglob
setopt nomatch

PROMPT='%F{green}%n@%m%f:%F{blue}%~%f %# '

alias ll='ls -lh'
alias la='ls -lha'
alias gs='git status'
alias v='nvim'

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
export HOSTNAME=$(hostname)

eval "$(starship init zsh)"

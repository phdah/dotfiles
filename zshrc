# Set up prompt
# PROMPT='%F{26}%n%f : %F{28}%~%f : '
PROMPT='%n : %~ : '
autoload -U colors && colors
#export PS1='%F{26}%K{000}%n'
export PS1="%F{214}%K{000}%m%F{015}%K{000}:%F{039}%K{000}%~%F{015}%K{000}\$ "


# Aliases
alias zshreload='source ~/.zshrc'

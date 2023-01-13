# Aliases
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
alias ls='ls --color'
alias bat='batcat'
alias vim='nvim'
alias gitl='git log --pretty=oneline'
alias gits='git status'
alias gitp='git pull'

# Functions
function gitall() {
git add . && git commit -m "$1" && git push
}
function cat() {
bat $1 --style=plain --paging=never
}
function rgf() {
rg --files | rg $1
}

# Default to emacs keybindings
bindkey -e

# Word skipping
bindkey ";5C" forward-word
bindkey ";5D" backward-word

# Path
source $HOME/.paths

### Set up prompt ###

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=$HOME/.zsh_history

# Show current git branch right of prompt
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '%b'

# Prompt definition
NEWLINE=$'\n'
PROMPT="%F{#D08770}%B%~${NEWLINE}%%%b "
RPROMPT='${vcs_info_msg_0_}'

### One time things ###

# Syntax highligthing
source $HOME/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export EDITOR=$(which nvim)

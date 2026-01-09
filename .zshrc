if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Add dotfiles bin to PATH
export PATH="$HOME/.dotfiles/bin:$PATH"

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt APPEND_HISTORY

# Enable completion
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Better directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Aliases
alias v='nvim'
alias vim='nvim'
alias vi='nvim'
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'


alias ls='ls -G'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias c='clear'
alias h='history'
alias mkdir='mkdir -p'

# Tmux aliases
alias t='tmux'
alias ta='tmux attach'
alias tn='tmux new -s'
alias tl='tmux ls'

# Quick directory aliases
alias dotfiles='cd ~/.dotfiles'
alias projects='cd ~/projects'

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Colors for ls
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# Node version manager (if using nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Starship prompt
eval "$(starship init zsh)"

# Custom functions
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

function extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
:


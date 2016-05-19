# Path to your oh-my-zsh configuration.
ZSH=$HOME/.homesick/repos/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="daveverwer"
#ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git cpanm perl bower github vagrant npm node nvm vundle gitignore)

source $ZSH/oh-my-zsh.sh

# ZSH config
# From http://stackoverflow.com/a/11873793/630490
setopt interactivecomments

# Include custom theme
# Override default $HOME/.hostAliases
#HOST_ALIASES=$HOME/.aliashost
source $HOME/.homesick/repos/dotfiles/themes/ljr.zsh-theme

# ===== Environmental variables =====

# source: http://superuser.com/a/39995
pathadd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}

# Customize items
pathadd "/bin"
pathadd "/sbin"
pathadd "/usr/sbin"
pathadd "/usr/bin"
pathadd "/usr/local/sbin"
pathadd "/usr/local/bin"
pathadd "/usr/lib/lightdm/lightdm"
pathadd "$HOME/bin"

# Time Tracker
source $HOME/.homesick/repos/dotfiles/timetracker.sh

# Perl local::lib
# if not already concatenated, concatenate
if [[ ":${PERL5LIB}:" != *:"$HOME/perl5/lib/perl5":*  ]]; then
  export PERL5LIB=$HOME/perl5/lib/perl5:$PERL5LIB
  pathadd "$HOME/perl5/bin"
fi

# Editor
export EDITOR="vim"

# Aliases
alias ll='ls -al'
alias la='ls -A'

alias ssh∆='ssh seanz@173.254.216.23'
alias sshj='ssh∆'
alias sshp='ssh seanz@173.254.216.2'

alias tmux="TERM=screen-256color-bce tmux"

# Git alias
alias gdc="git diff --cached"

# Add jiffy alias if able
if hash jiffy 2>/dev/null; then
   alias j='jiffy'
fi

# IRC remote tmux session with growl tunnel support
_growl_pre_irc() {
   # Initiate tunnel if it hasnt fired
   if ! ps ax | grep '[i]rssi' > /dev/null; then
      ~/irssi-growler/irssi_growler 2>&1 > /dev/null &!
   fi

   # connect to the remote tmux session
   ssh seanz@haxiom.io -t tmux attach -t irssi;

   # Get all the pids of growl related processes
   growl_pids=$( ps ax | grep '[i]rssi' | awk '{print $1}' )
   # Look through them with the \n delimiter
   while IFS="\n" read -r pid ; do
      kill $pid
   done <<<"$growl_pids"
}
alias irc="_growl_pre_irc"

source $HOME/.homesick/repos/homeshick/homeshick.sh

# Setup Z
source $HOME/.homesick/repos/z/z.sh

# Setup k
source $HOME/.homesick/repos/k/k.sh
alias k='k -A';

# Git permissions
#source $HOME/.homesick/repos/dotfiles/git-perm.sh

# DBICM Wrapper
source $HOME/.homesick/repos/dbic-migration-env/dbicm-env.sh

fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

# On mac for brew
if [[ $OSTYPE == "darwin"* ]]; then
  pathadd "/usr/local/bin"
fi

# Plenv setup
if hash plenv 2>/dev/null && [ -d $HOME/.plenv/bin ]; then
  pathadd "$HOME/.plenv/bin"
  pathadd "$HOME/.plenv/shims"
  eval "$(plenv init -)"
fi

# Rbenv setup
if hash rbenv 2>/dev/null && [ -d $HOME/.rbenv/bin ]; then
  pathadd "$HOME/.rbenv/bin"
  pathadd "$HOME/.rbenv/shims"
  eval "$(rbenv init -)"
fi

# nvm
if [ -d ~/.nvm ]; then
   export NVM_DIR=~/.nvm
   if [[ $OSTYPE == "darwin"* ]]; then
      source $(brew --prefix nvm)/nvm.sh
   fi
   autoload -U add-zsh-hook
   load-nvmrc() {
      if [[ -f .nvmrc && -r .nvmrc ]]; then
        nvm use
      fi
   }
   add-zsh-hook chpwd load-nvmrc
fi

# make it easier to run things in node_modules
if [ ! hash npm 2>/dev/null ]; then
   alias npm-exec='env PATH="$(npm bin):$PATH"'
   alias ne='npm-exec'
fi

###-begin-yo-completion-###
_yo_completion () {
  local cword line point words si
  read -Ac words
  read -cn cword
  let cword-=1
  read -l line
  read -ln point
  si="$IFS"
  IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                     COMP_LINE="$line" \
                     COMP_POINT="$point" \
                     yo-complete completion -- "${words[@]}" \
                     2>/dev/null)) || return $?
  IFS="$si"
}
compctl -K _yo_completion yo
###-end-yo-completion-###

# Perl6 via rakudobrew
if test -d $HOME/.rakudobrew; then
  pathadd "$HOME/.rakudobrew/bin"
fi

# Don't rename the window
export DISABLE_AUTO_TITLE=true

# Mobile development{{{
if [ -d $HOME/Library/Android ]; then
   alias adb=$HOME/Library/Android/sdk/platform-tools/adb
fi

# }}}


# Force completion scripts to be loaded Autocomplete
autoload -U compinit
compinit

# Highlighting on the cmd line (*.* )
if [ -d ~/.homesick/repos/zsh-syntax-highlighting ]; then
   source ~/.homesick/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Get to project root ( stolen from NickTomlin )
## Stolen from paul irish's dotfiles: https://github.com/paulirish/dotfiles/commit/e67d1bc03
if [[ $OSTYPE == "darwin"* ]]; then
  cdf() {  # short for cdfinder
    cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"
  }
fi

# Google Cloud SDK.
if [ -d $HOME/Library/Android ]; then
   # The next line updates PATH
   source "$HOME/google-cloud-sdk/path.zsh.inc"

   # The next line enables shell command completion
   source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

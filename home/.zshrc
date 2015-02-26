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
# Customize to your needs...
export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Perl local::lib
# if not already concatenated, concatenate
if [[ ":${PERL5LIB}:" != *:"$HOME/perl5/lib/perl5":*  ]]; then
   export PERL5LIB=$HOME/perl5/lib/perl5:$PERL5LIB
   export PATH=$HOME/perl5/bin:$PATH
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

# Git permissions
#source $HOME/.homesick/repos/dotfiles/git-perm.sh

# DBICM Wrapper
source $HOME/.homesick/repos/dbic-migration-env/dbicm-env.sh

fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

# On mac for brew
export PATH="/usr/local/bin:$PATH"

# Plenv setup
if command -v plenv >/dev/null 2>&1; then
   if [[ ":${PATH}:" != *":$HOME/.plenv/bin:"*  ]]; then
      export PATH="$HOME/.plenv/bin:$PATH"
      export PATH="$HOME/.plenv/shims:$PATH"
   fi
   eval "$(plenv init -)"
fi

# Rbenv setup
if command -v rbenv >/dev/null 2>&1; then
   if [[ ":${PATH}:" != *":$HOME/.rbenv/bin:"*  ]]; then
      export PATH="$HOME/.rbenv/bin:$PATH"
      export PATH="$HOME/.rbenv/shims:$PATH"
   fi
   eval "$(rbenv init -)"
fi

# nvm
if [ -d ~/.nvm ]; then
   export NVM_DIR=~/.nvm
   source $(brew --prefix nvm)/nvm.sh
fi

# Force completion scripts to be loaded Autocomplete
autoload -U compinit
compinit

# Highlighting on the cmd line (*.* )
source ~/.homesick/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
plugins=(git cpanm perl bower github vagrant npm node nvm vundle)

source $ZSH/oh-my-zsh.sh

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
alias irc="ssh seanz@haxiom.io -t tmux attach -t irssi"

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

# Plenv setup
export PATH="$HOME/.plenv/bin:$PATH"
export PATH="$HOME/.plenv/shims:$PATH"
eval "$(plenv init -)"

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Force completion scripts to be loaded Autocomplete
autoload -U compinit
compinit

# Highlighting on the cmd line (*.* )
source ~/.homesick/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git cpanm perl vundle)

source $ZSH/oh-my-zsh.sh

# Include custom theme
# Override default $HOME/.hostAliases
#HOST_ALIASES=$HOME/.aliashost 
source $HOME/.homesick/repos/dotfiles/themes/ljr.zsh-theme

# Customize to your needs...
export PATH=$PATH:/home/polok/perl5/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

# Perl local::lib
export PERL5LIB=$HOME/perl5/lib/perl5:$PERL5LIB
export PATH=$HOME/perl5/bin:$PATH

# some more ls aliases
alias ll='ls -al'
alias la='ls -A'

. $HOME/.homesick/repos/homeshick/homeshick.sh

# Setup Z
. $HOME/.homesick/repos/z/z.sh

# Setup k
. $HOME/.homesick/repos/k/k.sh

# Git permissions
. $HOME/.homesick/repos/dotfiles/git-perm.sh

# DBICM Wrapper
. $HOME/.homesick/repos/dbic-migration-env/dbicm-env.sh

fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

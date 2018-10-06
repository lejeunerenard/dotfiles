# Path to your oh-my-zsh configuration.
HOMESHICK_REPOS=$HOME/.homesick/repos
ZSH=$HOMESHICK_REPOS/oh-my-zsh

# Oh My Zsh Plugins
plugins=(gitfast cpanm perl bower github vagrant npm node nvm vundle gitignore)

source $ZSH/oh-my-zsh.sh

# ZSH config
# From http://stackoverflow.com/a/11873793/630490
setopt interactivecomments

setopt extendedglob

# Include custom theme
# Override default $HOME/.hostAliases
#HOST_ALIASES=$HOME/.aliashost
source $HOMESHICK_REPOS/dotfiles/themes/ljr.zsh-theme

# ===== Environmental variables =====
source "$HOMESHICK_REPOS/dotfiles/pathadd.zsh"

# Customize items
pathadd "/bin"
pathadd "/sbin"
pathadd "/usr/sbin"
pathadd "/usr/bin"
pathadd "/usr/local/sbin"
pathadd "/usr/local/bin"
pathadd "/usr/lib/lightdm/lightdm"
pathadd "$HOME/bin"

# Local exports
if [ -f $HOME/.exports ]; then
  source $HOME/.exports
fi

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
alias s="git status -s"

# Add jiffy alias if able
if hash jiffy 2>/dev/null; then
   alias j='jiffy'
fi

source $HOMESHICK_REPOS/homeshick/homeshick.sh

# Setup Z
source $HOME/.homesick/repos/z/z.sh

# Setup k
source $HOME/.homesick/repos/k/k.sh
alias k='k -A';

# DBICM Wrapper
source $HOME/.homesick/repos/dbic-migration-env/dbicm-env.sh

fpath=($HOMESHICK_REPOS/homeshick/completions $fpath)

# On mac for brew
if [[ $OSTYPE == "darwin"* ]]; then
  pathadd "/usr/local/bin"
fi

# Plenv setup
if hash plenv 2>/dev/null && [ -d $HOME/.plenv/bin ]; then
  pathadd "$HOME/.plenv/bin"
  pathadd "$HOME/.plenv/shims"

  # Source: `plenv init -`
  # Removed the duplicate PATH addition to avoid compounding PATH paths
  export PLENV_SHELL=zsh
  source "$HOME/.plenv/libexec/../completions/plenv.zsh"
  plenv() {
    local command
    command="$1"
    if [ "$#" -gt 0 ]; then
      shift
    fi

    case "$command" in
    rehash|shell)
      eval "`plenv "sh-$command" "$@"`";;
    *)
      command plenv "$command" "$@";;
    esac
  }
fi

# Rbenv setup
if hash rbenv 2>/dev/null && [ -d $HOME/.rbenv/bin ]; then
  pathadd "$HOME/.rbenv/bin"
  pathadd "$HOME/.rbenv/shims"
  load-rbenv() {
    if [[ -f .ruby-version && -r .ruby-version ]]; then
      if ! type rbenv > /dev/null; then
        eval "$(rbenv init -)"
      fi
    fi
  }
  add-zsh-hook chpwd load-rbenv
fi

# nvm
if [ -d $HOME/.nvm ]; then
  function load-nvm () {
    if [[ $OSTYPE == "darwin"* ]]; then
      export NVM_DIR=$HOME/.nvm
      [[ -s $(brew --prefix nvm)/nvm.sh ]] && source $(brew --prefix nvm)/nvm.sh
    else
      [[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
    fi
  }

  autoload -U add-zsh-hook
  load-nvmrc() {
    if [[ -f .nvmrc && -r .nvmrc ]]; then
      if ! type nvm > /dev/null; then
        load-nvm
      fi
      nvm use
    fi
  }
  add-zsh-hook chpwd load-nvmrc

  # Check for .nvmrc in pwd
  # TODO

  # Else autoload current version of node
  getStableNodeVersionDir() {
    NVM_DIR=$HOME/.nvm
    PATTERN='8.9*'
    SEARCH_PATTERN='8\.9'
    NVM_DIRS_TO_SEARCH=$NVM_DIR/versions/node
    NVM_NODE_PREFIX="node"
    # source: nvm
    VERSIONS="$(command find "${NVM_DIRS_TO_SEARCH}"/* -name . -o -type d -prune -o -path "${PATTERN}*" \
      | command sed -e "
          s#^${NVM_DIR}/##;
          \\#^[^v]# d;
          \\#^versions\$# d;
          s#^versions/##;
          s#^v#${NVM_NODE_PREFIX}/v#;
          \\#${SEARCH_PATTERN}# !d;
        " \
        -e 's#^\([^/]\{1,\}\)/\(.*\)$#\2.\1#;' \
      | command sort -t. -u -k 1.2,1n -k 2,2n -k 3,3n \
      | command sed -e 's#\(.*\)\.\([^\.]\{1,\}\)$#\2-\1#;' \
                    -e "s#^${NVM_NODE_PREFIX}-##;" \
    )"
    DIR=$NVM_DIRS_TO_SEARCH/$VERSIONS
    echo $DIR
  }
  setNodeToStableVersion() {
    NODE_DIR="$(getStableNodeVersionDir)"
    NODE_VERSION_BIN_DIR="$NODE_DIR/bin"
    pathadd $NODE_VERSION_BIN_DIR
    export NVM_BIN="$NODE_VERSION_BIN_DIR"
  }
  setNodeToStableVersion
fi

# make it easier to run things in node_modules
if [ ! hash npm 2>/dev/null ]; then
   alias npm-exec='env PATH="$(npm bin):$PATH"'
   alias ne='npm-exec'
fi

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
if [ -d $HOME/.homesick/repos/zsh-syntax-highlighting ]; then
   source $HOME/.homesick/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Get to project root ( stolen from NickTomlin )
## Stolen from paul irish's dotfiles: https://github.com/paulirish/dotfiles/commit/e67d1bc03
if [[ $OSTYPE == "darwin"* ]]; then
  cdf() {  # short for cdfinder
    cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"
  }
fi

# Google Cloud SDK.
# This will cause a dupe dir in $PATH on reload
if [ -d $HOME/Library/Android ]; then
   # The next line updates PATH
   source "$HOME/google-cloud-sdk/path.zsh.inc"

   # The next line enables shell command completion
   source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# Modular zsh loading per machine
if [[ -d "$HOME/.zshrc.d" && -n $HOME/.zshrc.d/*.zsh(#qN) ]]; then
  for file in $HOME/.zshrc.d/*.zsh; do
    source $file
  done
fi

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f $HOME/.nvm/versions/node/v7.10.1/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh ]] && . $HOME/.nvm/versions/node/v7.10.1/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh

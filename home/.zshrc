# Path to your oh-my-zsh configuration.
HOMESHICK_REPOS=$HOME/.homesick/repos
DOTFILES=$HOMESHICK_REPOS/dotfiles
ZSH=$HOMESHICK_REPOS/oh-my-zsh

# Oh My Zsh Plugins
plugins=(gitfast git cpanm perl bower github vagrant npm node nvm gitignore)

source $ZSH/oh-my-zsh.sh

# ZSH config
# From http://stackoverflow.com/a/11873793/630490
setopt interactivecomments

setopt extendedglob

# Auto Setup TERMINFO
if [ ! -d $HOME/.terminfo ]; then
  echo 'Compiling terminfo'
  source $DOTFILES/compile-terminfo.sh
fi

# Include custom theme
# Override default $HOME/.hostAliases
#HOST_ALIASES=$HOME/.aliashost
source $DOTFILES/themes/ljr.zsh-theme

# ===== Environmental variables =====
source "$DOTFILES/pathadd.zsh"

# Wipe out PATH w/ system default
# Copied from /etc/zprofile on MacOS 10.15.6
# TODO Decide if this is problematic for sub-shells as no inheritance is
# possible.
if [ -x /usr/libexec/path_helper ]; then
  PATH=''
  eval `/usr/libexec/path_helper -s`
fi

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

# On mac for brew
if [[ $OSTYPE == "darwin"* ]]; then
  pathadd "/usr/local/bin"
fi

# Perl local::lib
# if not already concatenated, concatenate
if [ -d $HOME/perl5/lib/perl5 ]; then
  if [[ ":${PERL5LIB}:" != *:"$HOME/perl5/lib/perl5":*  ]]; then
    export PERL5LIB=$HOME/perl5/lib/perl5:$PERL5LIB
  fi
  pathadd "$HOME/perl5/bin"
fi

# Plenv setup
if hash plenv 2>/dev/null; then
  if [ -d $HOME/.plenv/bin ]; then
    pathadd "$HOME/.plenv/bin"
  fi
  pathadd "$HOME/.plenv/shims"

  # Source: `plenv init -`
  # Removed the duplicate PATH addition to avoid compounding PATH paths
  export PLENV_SHELL=zsh
  source $(brew --prefix plenv)"/libexec/../completions/plenv.zsh"
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
  source "$DOTFILES/load-nvm.sh"

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

  # Else autoload current version of node
  getStableNodeVersionDir() {
    STABLE_MAJOR=12
    STABLE_MINOR=16
    NVM_DIR=$HOME/.nvm
    PATTERN="$STABLE_MAJOR.$STABLE_MINOR*"
    SEARCH_PATTERN="$STABLE_MAJOR\\.$STABLE_MINOR"
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
    PATH="$NODE_VERSION_BIN_DIR${PATH:+":$PATH"}"
    export NVM_BIN="$NODE_VERSION_BIN_DIR"
  }
  setNodeToStableVersion

  # Check for .nvmrc in pwd after loading default
  load-nvmrc
fi

# PHP {{{
[[ -e $HOME/.phpbrew/bashrc  ]] && source $HOME/.phpbrew/bashrc
export PHPBREW_RC_ENABLE=1
# }}}

# Perl6 via rakudobrew
if test -d $HOME/.rakudobrew; then
  pathadd "$HOME/.rakudobrew/bin"
fi

# Aliases
alias ll='ls -al'
alias la='ls -A'

alias today='date +%Y-%m-%d'
alias ssh='TERM=xterm-256color ssh'

# Git alias
alias gdc="git diff --cached"
alias s="git status -s"

function daily-uniq () {
  cd $HOME/raymarch
  git log -p -i -G "\"?name\"?:\s+['\"].*$1.*['\"]" | grep -i --color=never "\\+.*\s\"\?name\"\?:\s\+['\"].*$1.*['\"]" | perl -ne "print \$1.\"\n\" if /:\s*['\"](.*?)(?:-render\d|-test\d)?+['\"]/"
}

source $HOMESHICK_REPOS/homeshick/homeshick.sh

# Setup Z
source $HOME/.homesick/repos/z/z.sh

# Setup k
if [ -d $HOME/.homesick/repos/k ]; then
  source $HOME/.homesick/repos/k/k.sh
  alias k='k -A';
fi

fpath=($HOMESHICK_REPOS/homeshick/completions $fpath)

# Editor
export EDITOR="vim"

# make it easier to run things in node_modules
if hash npm 2>/dev/null; then
   alias npm-exec='env PATH="$(npm bin):$PATH"'
   alias ne='npm-exec'
fi

# Add jiffy alias if able
if hash jiffy 2>/dev/null; then
  alias j='jiffy'
  alias jiffy-delete-last='mongo jiffy --eval "db.timeEntry.findAndModify({ query: {}, sort: {\"_id\": -1}, remove: true })"'
  alias c='jiffy current'
  alias jd='jiffy done'
  alias jt='jiffy timesheet'

  function jiffy-change-last () {
    CMD='db.timeEntry.findAndModify({ query: {}, sort: {"_id": -1}, update: {$set:{"title":"'"$@"'"}} })'
    mongo jiffy --eval $CMD
  }

  alias jel="jiffy-change-last"
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

# FZF
if type fzf > /dev/null; then
  # Load key bindings assuming that fzf was installed with brew
  . $(brew --prefix)/opt/fzf/shell/key-bindings.zsh

  if type bat > /dev/null; then
    fzf_find_edit() {
      local file=$(
        fzf --no-multi --preview 'bat --color=always --line-range :500 {}'
      )
      if [[ -n $file  ]]; then
        $EDITOR $file
      fi
    }

    alias ffe='fzf_find_edit'
  fi

  if type fd > /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --color=never'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d . --color=never'
  fi

  # Todoist integration
  if type todoist > /dev/null; then
    source "$GOPATH/src/github.com/sachaos/todoist/todoist_functions_fzf.sh"
  fi
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

# ===== Autocompletes =====
# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f $HOME/.nvm/versions/node/v7.10.1/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh ]] && . $HOME/.nvm/versions/node/v7.10.1/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f $HOME/.nvm/versions/node/v8.9.2/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . $HOME/.nvm/versions/node/v8.9.2/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh

# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f $HOME/.nvm/versions/node/v8.9.2/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . $HOME/.nvm/versions/node/v8.9.2/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

function load-nvm () {
  if [[ $OSTYPE == "darwin"* ]]; then
    export NVM_DIR=$HOME/.nvm
    BREWFIX=$(brew --prefix nvm)/nvm.sh
    if [[ -s $BREWFIX ]]; then
      source $BREWFIX
    else
      [[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
    fi
  else
    [[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
  fi
}

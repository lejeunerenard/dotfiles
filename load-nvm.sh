function load-nvm () {
  if [[ $OSTYPE == "darwin"* ]]; then
    export NVM_DIR=$HOME/.nvm
    [[ -s $(brew --prefix nvm)/nvm.sh ]] && source $(brew --prefix nvm)/nvm.sh
  else
    [[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
  fi
}

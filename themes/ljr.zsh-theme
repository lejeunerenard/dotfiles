# Copied and modified from the oh-my-zsh theme from geoffgarside
# Red server name, green cwd, blue git status

autoload -U colors && colors

autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr ' %F{green}●'
zstyle ':vcs_info:*' unstagedstr ' %F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '\%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn hg
theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats '%b%c%u%B%F{green}'
    } else {
         # unstaged whole
        zstyle ':vcs_info:*' formats '%b%c%u%B %F{red}●%F{green}'
    }

    vcs_info
}

setopt prompt_subst
PROMPT='%{$FG[166]%}%m%{$reset_color%} $FG[073]%c%{$reset_color%} %b$FG[223]${vcs_info_msg_0_}%b%{$reset_color%} '

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd

#ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}("
#ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"

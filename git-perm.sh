# Copyright (c) 2013 Sean Zellmer @lejeunerenard under GPLv2

_git_permissions() {
   if [[ "$*" == /var/www/sites/* && ( $HOST == 'highsite-web.com' || $HOST == 'highsite-dev.com' ) ]]
   then
      SITES_FOLDER=$(echo $* | sed -e 's/\/var\/www\/sites\///g' | sed -e 's/\/.*//g')
      if [ -d /var/www/sites/$SITES_FOLDER/xm_client/ ]
      then
         sudo find /var/www/sites/$SITES_FOLDER -type d -name ".git" -prune -o -name ".*" -prune -o -exec chown www-data.admins {} \;
         sudo find /var/www/sites/$SITES_FOLDER -type d -name ".git" -prune -o -name ".*" -prune -o -exec chmod 770 {} \;

         sudo find /var/www/sites/$SITES_FOLDER/.git -exec chown seanz.admins {} \;
         sudo find /var/www/sites/$SITES_FOLDER/.git -exec chmod 770 {} \;

         sudo find /var/www/sites/$SITES_FOLDER -name ".*" -exec chmod 770 {} \;
         sudo find /var/www/sites/$SITES_FOLDER -name ".*" -exec chown seanz.admins {} \;
      fi
   fi
}

alias ${_GIT_PERM_CMD:-git-perm}='_git_permissions 2>&1'

if compctl >/dev/null 2>&1; then
    # zsh
    # populate directory list, avoid clobbering any other precmds.
    _git_permissions_precmd() {
       _git_permissions "${PWD:A}"
    }
    [[ -n "${precmd_functions[(r)_git_permissions_precmd]}" ]] || {
        precmd_functions+=(_git_permissions_precmd)
    }
elif complete >/dev/null 2>&1; then
    # bash
     # populate directory list. avoid clobbering other PROMPT_COMMANDs.
     grep "_git_permissions" <<< "$PROMPT_COMMAND" >/dev/null || {
         PROMPT_COMMAND="$PROMPT_COMMAND"$'\n''_git_permissions "$(pwd 2>/dev/null)" 2>/dev/null;'
     }
fi

# Copyright (c) 2013 Sean Zellmer @lejeunerenard under GPLv2

_git_permissions() {
   if [[ $HOST == 'highsite-dev.com' ]]
   then
      if [ "$(git rev-parse --git-dir 2>/dev/null)" ]
      then
         GIT_DIR="$(git rev-parse --git-dir)"
         sudo chown -R seanz.admins $GIT_DIR
         sudo chmod -R 770 $GIT_DIR
      fi
   fi

   if [[ "$*" == /var/www/sites/* && ( $HOST == 'highsite-dev.com' ) ]]
   then
      # Latest Change file
      : ${GIT_PERM_CACHE:=$HOME/.git-perm}
      # Touch file to avoid errors
      [ ! -e $GIT_PERM_CACHE ] && touch $GIT_PERM_CACHE

      # Get Sites folder name
      SITES_FOLDER=$(echo $* | sed -e 's/\/var\/www\/sites\///g' | sed -e 's/\/.*//g')

      # Check if Highsite
      if [ -d /var/www/sites/$SITES_FOLDER/xm_client/ ]
      then

         #echo "First: "$(find /var/www/sites/$SITES_FOLDER/ -name ".git" -prune -o -type f -printf "%C@\n" | sort -nr | head -1 | sed -e 's/\..*//g')
         #echo "Second: "$(awk -v site=$SITES_FOLDER 'tolower($1) == tolower(site) { print substr($0, index($0,$2)) }' $GIT_PERM_CACHE)

         if [ $(grep -vqi '^'$SITES_FOLDER'\s' $GIT_PERM_CACHE) ] || [[ $(find /var/www/sites/$SITES_FOLDER/ -name ".git" -prune -o -type f -printf "%C@\n" | sort -nr | head -1 | sed -e 's/\..*//g') -gt $(awk -v site=$SITES_FOLDER 'tolower($1) == tolower(site) { print substr($0, index($0,$2)) }' $GIT_PERM_CACHE) ]]
         then
            echo "Setting Permissions..."
            sudo find /var/www/sites/$SITES_FOLDER -type d -name ".git" -prune -o -name ".*" -prune -o -exec chown www-data.admins {} \;
            sudo find /var/www/sites/$SITES_FOLDER -type d -name ".git" -prune -o -name ".*" -prune -o -exec chmod 770 {} \;
   
            sudo find /var/www/sites/$SITES_FOLDER/.git -exec chown seanz.admins {} \;
            sudo find /var/www/sites/$SITES_FOLDER/.git -exec chmod 770 {} \;
   
            sudo find /var/www/sites/$SITES_FOLDER -name ".*" -exec chmod 770 {} \;
            sudo find /var/www/sites/$SITES_FOLDER -name ".*" -exec chown seanz.admins {} \;
   
            sudo find /var/www/sites/$SITES_FOLDER -name ".htaccess" -exec chown www-data.admins {} \;
            awk '!/'$SITES_FOLDER'/' $GIT_PERM_CACHE > temp && mv temp $GIT_PERM_CACHE
            echo $SITES_FOLDER" "$(find /var/www/sites/$SITES_FOLDER/ -name ".git" -prune -o -type f -printf "%C@\n" | sort -nr | head -1 | sed -e 's/\..*//g') >> $GIT_PERM_CACHE
         fi
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

#!/bin/sh

_addEntry () {
  # Columns are:
  # Date | Entered into DS | Activity description
  MSG=$( date --rfc-3339=seconds )"\t\t""$@";
  echo $MSG >> ~/.tt-sheet.log
}
_timetracker () {
  _addEntry "$@"
}

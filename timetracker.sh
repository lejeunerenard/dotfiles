#!/bin/sh

_addEntry () {
  MSG=$( date --rfc-3339=seconds )"\t"$1;
  echo $MSG >> ~/.tt-sheet.log
}
_timetracker () {
  _addEntry $1
}

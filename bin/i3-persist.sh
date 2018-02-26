#!/bin/sh

FILE="`readlink -f "$0"`"

# import library
. "`dirname $FILE`/../src/i3-persist-common.sh"

# Main
create_temporary_directory
remove_expired_container_locks

if [ -z "$1" -o "$1" = "--help" ]
then
  echo "Syntax: i3-persist [lock|unlock|toggle|kill] [id]"
  exit 0
fi

CONTAINER=`argument_or_focused_container "$2"`

if [ "$1" = "lock" ]
then
  lock_container "$CONTAINER"
  exit 0
fi

if [ "$1" = "unlock" ]
then
  unlock_container "$CONTAINER"
  exit 0
fi

if [ "$1" = "toggle" ]
then
  if ! is_container_locked "$CONTAINER"
  then
    lock_container "$CONTAINER"
  else
    unlock_container "$CONTAINER"
  fi
  exit 0
fi

if [ "$1" = "kill" ]
then
  ! is_container_locked "$CONTAINER" && ! has_any_locked_child_containers "$CONTAINER" && i3-msg "[con_id=\"$CONTAINER\"]" kill
  exit 0
fi

printf "i3-persist: invalid operand\nTry 'i3-persist --help' for more information.\n"
exit 1

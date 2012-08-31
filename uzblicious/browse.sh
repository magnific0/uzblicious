#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script run the test1 or test2 over a machine.

OPTIONS:
   -h      Show this message
   -s      Name of script (bookmarks list by default)
   -n      New window
EOF
}

SCRIPTRUN=list
NEWWINDOW=false

while getopts h:s:n o
do	case "$o" in
	h)	usage
		exit 1;;
	s)	SCRIPTRUN="$OPTARG";;
	n)      NEWWINDOW=true;;
	[?])	usage
		exit 1;;
	esac
done

echo $SCRIPTRUN
echo $NEWWINDOW

source ~/.config/uzbl/uzblicious.conf
prompt_script=$del_scripts_dir/$SCRIPTRUN.sh

goto=$(. $prompt_script)
if [ ${#goto} -gt 0 ]; then
  if $NEWWINDOW; then
    eval "uzbl-browser \"$goto\" 2> /dev/null"
  else    
    echo "uri $goto" | socat - "unix-connect:$UZBL_SOCKET"
  fi
fi

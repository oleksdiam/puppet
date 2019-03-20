#!/bin/bash

# USAGE: 
# sh puppet-check.sh -p "/path/to/root/directory/" -- file1 file2 ... fileN

# This script is intended for syntax validation of puppet files 
# (mainfests and templates)
# which full paths to are passed as a script parameters.
# Script require installed Puppet (and Ruby as it part) 
# on instance where it have to execute.

# OPTIONS:
# -p PREFIX_PATH option describes absolute path to listed file's root directory
# when relative to it path are passed in file description. 
# It isn't required when script is placed in and runs from this directory.

# Script doesn't any responce in case of successful validation
# otherwise passes error notifications on stdout

PREFIX_PATH=""
while [ -n "$1" ]
do
case "$1" in
-p) PREFIX_PATH="$2"
shift ;;
--) shift
break ;;
*) echo "$1 is not an usable option";;
esac
shift
done
for arg  in "$@"
do
  argv="$PREFIX_PATH""${arg}"

if [ ${arg##*.} = 'erb' ]; then
  erb -P -x -T '-' "$argv" | ruby -c | tr -d 'Syntax OK\n'
elif [ ${arg##*.} = 'pp' ]; then
  puppet parser validate "$argv"
elif [ ${arg##*.} = 'epp' ]; then
  puppet epp validate "$argv"
else
  continue
fi
done

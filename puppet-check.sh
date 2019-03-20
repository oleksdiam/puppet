#!/bin/bash

# USAGE: 
# sh puppet-check.sh -p "/path/to/root/directory/" file1 file2 ... fileN

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
while getopts ":p:" opt; do
	case $opt in
		p) PREFIX_PATH="${OPTARG}" ;;
		\?) logging "critical" "Invalid option: -${OPTARG}." ; exit 253 ;;
		:) logging "critical" "Option -${OPTARG} requires an argument." ; exit 252 ;;
	esac
done
shift $(($OPTIND - 1))

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

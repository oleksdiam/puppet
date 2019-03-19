#!/bin/bash

# This script is intended for syntax validation of puppet files 
# (mainfests and templates)
# which full paths to are passed as a script parameters.
# Script require installed Puppet (and Ruby as it part) 
# on instance where it have to execute.

# Script doesn't any responce in case of successful validation
# otherwise passes error notifications on stdout

for arg  in "$@"
do
if [ ${arg##*.} = 'erb' ]; then
  exec erb -P -x -T '-' "$arg" | ruby -c | tr -d 'Syntax OK\n'
elif [ ${arg##*.} == 'pp' ]; then
  exec puppet parser validate "$arg"
elif [ ${arg##*.} == 'epp' ]; then
  exec puppet epp validate "$arg"
else
  continue
fi
done

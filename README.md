# puppet_check

# This script is intended for syntax validation of puppet files 
# (mainfests and templates)
# which full paths to are passed as a script parameters.
# Script require installed Puppet (and Ruby as it part) 
# on instance where it have to execute.

# Script doesn't any responce in case of successful validation
# otherwise passes error notifications on stdout
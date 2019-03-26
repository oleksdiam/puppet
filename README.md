# puppet-check.sh
USAGE: 
sh puppet-check.sh -p "/path/to/root/directory/" -- file1 file2 ... fileN
where file1...fileN - relative paths to listed files
# webhook-parser.py
Require: puppet 2
USAGE: 
    webhook-parser.py -p <pattern in the filepath>  <webhook payload file>
DEFAULT VALUES:
    pattern       = 'puppet'
Return:
    String with paths to added/modified files in the repository separated by spaces
    
#!/usr/bin/env python

'''
USAGE: webhook-parser.py -a/--authtoken= <authorization token> -p <pattern in the filepath>  <webhook payload file>)
   or  webhook-parser.py -f/--filewithtoken= <file, that contains token> -p <pattern in the filepath> <webhook payload file>')
DEFAULT VALUES:
    filewithtoken = '/home/<username>/.ssh/github-token'
    pattern       = 'puppet'
'''
import json
import os,sys, getopt
import subprocess

# get username for token  path   !!!!!!!!!1
# This script has to receive github 'push' webhook payload in json format
# 

def cliExec(command, arg):

    process = subprocess.Popen([command, arg], stdout=subprocess.PIPE)
    output, error = process.communicate()
    return output, error

def main(argv):

    authToken    = ''
    pattern      = 'puppet'
    tokenPath    = '/home/odiam/.ssh/github-token'
    tempTreeFile = "/tmp/git-tree-recursive.json"

    try:
        opts, args = getopt.getopt(argv,"a:f:p:",["authtoken=","filewithtoken="])
    except getopt.GetoptError:
        print('getopt error. Usage: ' + sys.argv[0] + ' -a/--authtoken= <authorization token>  <webhook payload file>')
        print(' or ' + sys.argv[0] + ' -f/--filewithtoken= <file, that contains token> <webhook payload file>')
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-a", "--authtoken"):
            authToken = arg
        elif opt in ("-f", "--filewithtoken"):
            tokenPath = arg
        elif opt in ("-p", "--pattern"):
            pattern = arg
        else:
            print('Usage: ' + sys.argv[0] + ' -a/--authtoken= <authorization token>  <webhook payload file>')
            sys.exit()

    with  open(args[0]) as payload:
        jsonData = json.load(payload)
    head_sha = jsonData.get("after")
    repo     = jsonData.get("repository")
    commits  = jsonData.get("commits")

    commitList = []
    for item in range(len(commits)):
        itemID = commits[item].get("id")
        commitList.append(itemID)
    
    trees_url_prefix = str.split(str(repo.get("trees_url")),'{')[0]
    authToken = cliExec('cat', tokenPath)[0].replace("\n","")
    
    curlArg = trees_url_prefix + '/'+ head_sha + '?recursive=1 -H "Authorization: token ' + authToken +'" -o '+ tempTreeFile
    os.system("curl "+curlArg)
    # LoadedTree = json.loads(os.system("curl "+curlArg))
    
    with open(tempTreeFile) as TreeFile:
        # if not truncated
        LoadedTree = json.load(TreeFile)
    # os.remove(tempTreeFile)

    pathList = []
    treeList   = LoadedTree.get("tree")

    for item in range(len(treeList)):
        itemPath = treeList[item].get("path")
        itemSHA  = treeList[item].get("sha")
        if (itemSHA in commitList) and (pattern in itemPath):
            pathList.append(itemPath)
    
    print(" ".join(pathList))
    

if __name__ == "__main__":
    main(sys.argv[1:])

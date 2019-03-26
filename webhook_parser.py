#!/usr/bin/env python

'''
USAGE: webhook-parser.py  -p <pattern in the filepath>  <webhook payload file>)

DEFAULT VALUES:
    pattern       = 'puppet'
'''
import json
import os,sys, getopt
import subprocess


def parse_payload(data, pattern):

    with  open(data) as payload:
        jsonData = json.load(payload)
    head_sha = jsonData.get("after")
    repo     = jsonData.get("repository")
    commits  = jsonData.get("commits")

    addModList = []
    removedList =[]
    for item in range(len(commits)):
        itemID = commits[item].get("id")
        if commits[item].get("removed"):
            removedList.append(commits[item].get("removed"))
        else:
            if commits[item].get("added"):
                addModList.append(commits[item].get("added"))
            else:
                addModList.append(commits[item].get("modified"))

    pathList = []
    for item in range(len(addModList)):
        for itemPath in range(len(addModList[item])):
            iteration = addModList[item][itemPath]
            if (pattern in iteration):
                pathList.append(iteration)
    
    return pathList

def main(argv):

    pattern      = 'puppet'

    try:
        opts, args = getopt.getopt(argv,"p:",["pattern="])
    except getopt.GetoptError:
        print('getopt error. Usage: ' + sys.argv[0] + ' -p <pattern  <webhook payload file>')
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-p", "--pattern"):
            pattern = arg
        else:
            print('Usage: ' + sys.argv[0] + ' -p <pattern  <webhook payload file>')
            sys.exit()

    print(" ".join(parse_payload(args[0], pattern)))

if __name__ == "__main__":
    main(sys.argv[1:])

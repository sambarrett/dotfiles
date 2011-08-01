#!/usr/bin/env python

links = [
  ['.vimrc','vim/vimrc'],
  ['.vim','vim'],
  ['.pylintrc','pylintrc'],
  ['.pentadactylrc','pentadactylrc'],
  ['.xmonad','xmonad'],
  ['.gestures.dat','gestures.dat']
]

computerSpecificLinks = [
  ['.xmobarrc','xmobarrc']
]

import os, socket

def getLinkName(linkName):
  return os.path.expanduser(os.path.join('~/',linkName))

def handleLink(linkName,source,make):
  link = getLinkName(linkName)
  if make:
    try:
      os.symlink(os.path.abspath(source),link)
    except:
      import sys
      print >>sys.stderr,'Failed to make link for',source,link
  else:
    try:
      os.unlink(link)
    except OSError:
      pass

def handleLinks(make=True):
  for linkName,source in links:
    handleLink(linkName,source,make)

  hostname = socket.gethostname()
  for linkName,source in computerSpecificLinks:
    handleLink(linkName+hostname,source,make)

if __name__ == '__main__':
  handleLinks(make=False)
  handleLinks(make=True)

#!/usr/bin/env python

class Link(object):
  def __init__(self,src,dest=None,computerSpecific=False):
    self.src = src
    self.dest = dest
    self.computerSpecific = computerSpecific
    if self.dest is None:
      self.dest = '.' + src

links = [
  Link('vim/vimrc','.vimrc'),
  Link('vim'),
  Link('pylintrc'),
  Link('pentadactylrc'),
  Link('xmonad'),
  Link('gestures.dat'),
  Link('bashrc'),
  Link('sshconfig','.ssh/config'),
  Link('bin','bin'),
  Link('toprc'),
  Link('inputrc'),
  Link('xmobarrc',computerSpecific=True)
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
  hostname = socket.gethostname()
  for link in links:
    src = link.src
    if link.computerSpecific:
      src += '-' + hostname
    handleLink(link.dest,src,make)

if __name__ == '__main__':
  handleLinks(make=False)
  handleLinks(make=True)

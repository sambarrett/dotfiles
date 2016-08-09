#!/usr/bin/env python

class Link(object):
  def __init__(self,src,dest=None,computerSpecific=False,sudo=False):
    self.src = src
    self.dest = dest
    self.computerSpecific = computerSpecific
    self.sudo = sudo
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
  Link('subversionConfig','.subversion/config'),
  Link('bin','bin'),
  Link('toprc'),
  Link('inputrc'),
  Link('gitconfig'),
  Link('gitignore'),
  Link('xmobarrc',computerSpecific=True),
  Link('trayerStart','bin/trayerStart',computerSpecific=True),
  Link('xmonad.desktop','/usr/share/xsessions/xmonad.desktop',sudo=True),
]

import os, socket, sys, subprocess

def getLinkName(linkName):
  return os.path.expanduser(os.path.join('~/',linkName))

def handleLink(linkName,source,make,sudo):
  link = getLinkName(linkName)
  source = os.path.abspath(source)
  if make:
    try:
      if sudo:
        subprocess.check_call(['sudo','ln','-s',source,link])
      else:
        os.symlink(source,link)
    except OSError as err:
      print >>sys.stderr,'Failed to make link for',source,link
      print >>sys.stderr,err
      print >>sys.stderr,'Continuing'
  else:
    try:
      if sudo:
        subprocess.check_call(['sudo','unlink',link])
      else:
        os.unlink(link)
    except OSError as err:
      if err.errno != 2: # errno 2 is if no such file exists
        print >>sys.stderr,err

def handleLinks(make=True,sudo=False):
  hostname = socket.gethostname()
  for link in links:
    src = link.src
    if link.computerSpecific:
      src += '-' + hostname
    if not(sudo) and link.sudo:
      continue
    handleLink(link.dest,src,make,link.sudo)

if __name__ == '__main__':
  from optparse import OptionParser
  parser = OptionParser('makeLinks.py [options]')
  parser.add_option('--sudo',action='store_true',dest='sudo',default=False,help='Do actions requiring sudo access')
  options,args = parser.parse_args()
  assert(len(args) == 0)
  handleLinks(make=False,sudo=options.sudo)
  handleLinks(make=True,sudo=options.sudo)

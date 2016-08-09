#!/usr/bin/env python

import getpass
import gnomekeyring as gk

def setupHoratio():
  username = raw_input('Enter your CS username: ')
  password = getpass.getpass('Enter your CS password: ')
  attr = {'username':username}
  gk.item_create_sync('login', gk.ITEM_NETWORK_PASSWORD, 'Horatio Login', attr, password, True);

  #sysCall ("sudo ln -sf ~/scripts/99horatio /etc/NetworkManager/dispatcher.d/99horatio")

if __name__ == '__main__':
  setupHoratio()


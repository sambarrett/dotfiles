#!/usr/bin/python

import urllib, urllib2
import gnomekeyring as gk

url = 'https://horatio.cs.utexas.edu/login.cgi' # write your URL here

#obtain login info
username = "if you want a default username"
password = "if you want a default password"
keyring = 'login'
usernameName = 'Horatio username'
passwordName = 'Horatio password'

for id in gk.list_item_ids_sync(keyring):
  item = gk.item_get_info_sync(keyring, id)
  if item.get_display_name() == usernameName:
    username = item.get_secret()
  elif item.get_display_name() == passwordName:
    password = item.get_secret();

values = {'username' : username,
          'password' : password
          }

try:
    data = urllib.urlencode(values)          
    req = urllib2.Request(url, data)
    response = urllib2.urlopen(req)
except Exception, detail: 
    print "Err ", detail

#!/usr/bin/python

import urllib, urllib2
import gnomekeyring as gk

url = 'https://horatio.cs.utexas.edu/login.cgi' # write your URL here

#obtain login info
keyring = 'login'
name = 'Horatio Login'
username = None
password = None

for id in gk.list_item_ids_sync(keyring):
  item = gk.item_get_info_sync(keyring, id)
  if item.get_display_name() == name:
    password = item.get_secret()
    attr = gk.item_get_attributes_sync(keyring,id)
    if 'username' in attr:
      username = attr['username']
    break

if password is None:
  import sys
  print >>sys.stderr,'No password found in %s' % name
  sys.exit(1)
if username is None:
  import sys
  print >>sys.stderr,'No username found in %s' % name
  sys.exit(1)

values = {'username' : username,
          'password' : password
          }


try:
    data = urllib.urlencode(values)          
    req = urllib2.Request(url, data)
    response = urllib2.urlopen(req)
except Exception, detail: 
    print "Err ", detail

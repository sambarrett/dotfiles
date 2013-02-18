#!/usr/bin/python

import urllib, urllib2
import gnomekeyring as gk

url = 'https://horatio.cs.utexas.edu/login.cgi' # write your URL here

#obtain login info
keyring = 'login'
name = 'Horatio Login'
username = None
password = None

def isLoginRequired():
  import subprocess
  res = subprocess.call(['ping','-c','1','-W','1','www.google.com'],stdout=open('/dev/null','w'))
  if res == 0:
    print 'Login unnecessary'
    return False
  res = subprocess.call(['ping','-c','1','-W','1','horatio.cs.utexas.edu'],stdout=open('/dev/null','w'))
  if res == 0:
    return True
  else:
    print 'No network connection'
    return False

def main():
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
      print 'Login successful'
  except Exception, detail: 
      print "Err ", detail

if __name__ == '__main__':
  if isLoginRequired():
    main()

# dotfiles
- To run: `wget https://raw.githubusercontent.com/sambarrett/dotfiles/master/bootstrap && bash bootstrap`
- If you don't yet have github access setup:
  - `ssh-keygen -t rsa -b 4096 -C "EMAIL_ADDRESS"`
  - `cat ~/.ssh/id_rsa.pub`
  - then go to: https://github.com/settings/keys and add the ssh key
- Then: `git clone git@github.com:sambarrett/dotfiles.git`
- And finally: `cd dotfiles && ./setupLinks --sudo`

# Get the system wide default PATH.  
# It provides access to software you need.  It differs from one
# platform to another.  The department staff maintains it as a
# basic part of your working environment.  We will be very reluctant
# to bail you out if you ignore this warning and munge your PATH.
# !! DO NOT REMOVE THIS BLOCK !!
if [ -f /lusr/lib/misc/path.sh ]; then
  . /lusr/lib/misc/path.sh
fi
# !! DO NOT REMOVE THIS BLOCK !!

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# set executable path
export PATH=$HOME/bin:$PATH # make my bin first, don't mess up my bin or bad things can happen
export PATH=$PATH:/lusr/opt/qt-4.3.2/bin:/lusr/condor/bin:/lusr/opt/condor/bin:
export PATH=$PATH:~/apps/usr/bin:~/apps/bin:~/bin/transfer-bin
# set ld library path
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lusr/opt/qt-4.4.0/lib:/u/sbarrett/apps/lib
# setup the python path
#export PYTHONPATH=$PYTHONPATH:/lusr/lib/python2.5/site-packages
# compile flags
export CFLAGS="-I/u/sbarrett/apps/include -L/u/sbarrett/apps/lib"
export CPPFLAGS="-I/u/sbarrett/apps/include -L/u/sbarrett/apps/lib"

name=`hostname`
if [ $name = "ubik" ] || [ $name = "scannerdarkly" ]
then
  onLabMachine=
else
  onLabMachine=y
fi

# Auto-screen invocation. see: http://taint.org/wk/RemoteLoginAutoScreen
# if we're coming from a remote SSH connection, in an interactive session
# then automatically put us into a screen(1) session.   Only try once
# -- if $STARTED_SCREEN is set, don't try it again, to avoid looping
# if screen fails for some reason.
if [ "$PS1" != "" -a "${STARTED_SCREEN:-x}" = x -a "${SSH_TTY:-x}" != x ]
then
  STARTED_SCREEN=1 ; export STARTED_SCREEN
  [ -d $HOME/lib/screen-logs ] || mkdir -p $HOME/lib/screen-logs
  sleep 1
  byobu -RR && exit 0
  # normally, execution of this rc script ends here...
  echo "Screen failed! continuing with normal bash startup"
fi
# [end of auto-screen snippet]

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac


if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
    else
  color_prompt=
    fi
fi

function PromptExitCode()
{
  RETCODE="$?"
  RED='\e[1;31m'
  OFF='\e[0m'

  if [[ "${RETCODE}" -eq "0" ]]
  then
    RET_PROMPT="[${RETCODE}]"
  else
    RET_PROMPT="\[${RED}\][${RETCODE}]\[${OFF}\]"
  fi
  MYPWD=`pwd | sed 's/\/home\/sam/\~/' | sed 's/\/v\/filer4b\/v20q001\/sbarrett/\~/' | sed 's/\/u\/sbarrett/\~/'`
  if [ $onLabMachine ]
  then
    PROMPT="\h:${MYPWD}${RET_PROMPT}\$ "
    PS1="\[\033];\h:${MYPWD}\007\]${PROMPT}"
  else
    PROMPT="${MYPWD}${RET_PROMPT}\$ "
    PS1="\[\033];${MYPWD}\007\]${PROMPT}"
  fi
}
case "$TERM" in
xterm*|rxvt*|screen*)
  PROMPT_COMMAND=PromptExitCode
  ;;
*)
  ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias g="egrep --exclude-dir=.svn --exclude=\*tags\* --exclude=\*core_wrap.cpp\* -I -n "
NUM_PROCESSORS=`grep -c processor /proc/cpuinfo`
alias make="make -j ${NUM_PROCESSORS}"

if [ $onLabMachine ]
then
  MAIL=${HOME}/mailbox
  MAILER=mush
  EDITOR=vi
  PS1="`uname -n`$ "
  NNTPSERVER="newshost.cc.utexas.edu"

  PRINTER=lw50

  export MAIL PS1 EDITOR MAILER PRINTER

  export HISTCONTROL=ignoredups
  alias ls='ls --color=always'
  alias ll='ls -l'
  alias ctags='~/apps/bin/ctags'
  alias vim='~/apps/bin/vim'
  alias gvim='~/apps/bin/gvim'
  alias condor_qr='condor_q sbarrett | grep running'
  alias condor_qar='condor_q | grep running'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

set -o vi
# completions
complete -f -o default -X '!*.+(condor|CONDOR)' condor_submit


if [ -f ~/.bashrc.nao ]; then
  . ~/.bashrc.nao
fi

if [ -f ~/.bashrc.ros ]; then
. ~/.bashrc.ros
fi

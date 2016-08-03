# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# set executable path
export PATH=$HOME/bin:$PATH # make my bin first, don't mess up my bin or bad things can happen

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
  USERNAME=`whoami`
  if [ $USERNAME == 'sam' -o $USERNAME == 'sbarrett' ]
  then
    USERNAME=''
  else
    if [ $onLabMachine ]
    then
      USERNAME="\[${RED}\]$USERNAME\[${OFF}\]@"
    else
      USERNAME="\[${RED}\]$USERNAME\[${OFF}\]:"
    fi
  fi

  if [[ "${RETCODE}" -eq "0" ]]
  then
    RET_PROMPT="[${RETCODE}]"
  else
    RET_PROMPT="\[${RED}\][${RETCODE}]\[${OFF}\]"
  fi
  MYPWD=`pwd | sed 's/\/home\/sam/\~/'`
  PROMPT="$USERNAME${MYPWD}${RET_PROMPT}\$ "
  PS1="\[\033];${MYPWD}\007\]${PROMPT}"
}
case "$TERM" in
xterm*|rxvt*|screen*)
  PROMPT_COMMAND=PromptExitCode
  ;;
*)
  ;;
esac

#export GREP_OPTIONS="--exclude-dir=.svn"
## enable color support of ls and also add handy aliases
#if [ -x /usr/bin/dircolors ]; then
    #test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    ##alias dir='dir --color=auto'
    ##alias vdir='vdir --color=auto'

    #export GREP_OPTIONS="$GREP_OPTIONS --color=auto"
#fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

NUM_PROCESSORS=`grep -c processor /proc/cpuinfo`
alias make="make -j ${NUM_PROCESSORS}"
alias vime="vim"

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

source /opt/ros/kinetic/setup.bash

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

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
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

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
OFF='\e[0m'

find_git_branch() {
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch="\[${RED}\]detached*\[${OFF}\]"
    fi
    git_branch="\[${BLUE}\]($branch)\[${OFF}\]"
  else
    git_branch=""
  fi
}

find_git_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    git_dirty="\[${YELLOW}\]*\[${OFF}\]"
  else
    git_dirty=""
  fi
}

function PromptExitCode()
{
  RETCODE="$?"
  USERNAME=`whoami`
  if [ $USERNAME == 'sam' -o $USERNAME == 'sbarrett' ]
  then
    USERNAME=''
  else
    USERNAME="\[${RED}\]$USERNAME\[${OFF}\]:"
  fi

  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    HOST="\[${GREEN}\]\h\[${OFF}\]:"
  else
    HOST=""
  fi

  if [[ "${RETCODE}" -eq "0" ]]
  then
    RET_PROMPT="[${RETCODE}]"
  else
    RET_PROMPT="\[${RED}\][${RETCODE}]\[${OFF}\]"
  fi
  MYPWD=`pwd | sed 's/\/home\/sam/\~/'`
  find_git_branch
  find_git_dirty
  if [ -z "${VIRTUAL_ENV}" ]
  then
    ENV_PROMPT=""
  else
    venv_path=`echo ${VIRTUAL_ENV} | sed 's/\/home\/sam/\~/'`
    ENV_PROMPT="(${venv_path})"
  fi
  PROMPT="$USERNAME${MYPWD}${git_branch}${git_dirty}${ENV_PROMPT}${RET_PROMPT}\$ "
  PS1="${HOST}\[\033];${MYPWD}\007\]${PROMPT}"
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

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

NUM_PROCESSORS=`grep -c processor /proc/cpuinfo`
alias make="make -j ${NUM_PROCESSORS}"
alias vime="vim"
alias cpplint="cpplint --linelength=120"

export EDITOR="vim"

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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f ~/.bashrc_additions ]; then
  . ~/.bashrc_additions
fi

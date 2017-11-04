#!/bin/sh
#
# .bash_aliases 
#

# Use wsl.open for win10 with silly / to \  
function wsl.open {
  if [ $# -eq 0 ] ; then
    printf "Usage: open { /path/ | URL }\n"
  else
    cmdarg=$(echo $@ | sed -e 's/\//\\/g')
    cmd.exe /c "start $cmdarg"
  fi
}

# Use mys.open for cygwin/git with cygpath
function msys.open {
  if [ $# -eq 0 ] ; then
    printf "Usage: open { file | URL }\n"
  else
      if [ -r "$1" ] ; then
        start `cygpath -w -s "$1"`
      else
        start $@
      fi
  fi
}

# Use xdg.open for linux  
function xdg.open {
  if [ $# -eq 0 ] ; then
    printf "Usage: open { file | URL }\n"
    xdg-open --help
  else
    xdg-open "$@" &> /dev/null &
  fi
}

# OS specific aliases
case $OSTYPE in
  msys*)
     alias open=msys.open
     alias doh='winpty docker'
     alias topm="TASKLIST -fi \"memusage gt 16000\" | sort -r -n -k5"
     ;;
  linux-gnu)
     if [ $(uname -r) == "4.4.0-43-Microsoft" ] ; then
       alias open=wsl.open
       # So so sudo ln -s /mnt/c/Users /Users 
       [ -d "/Users/$USER" ] && cd /Users/$USER
     else
       alias open=xdg.open
     fi
     alias topc='top -o %CPU' 
     alias topm='top -o %MEM' 
     ;;
  darwin*)
     alias topc='top -o cpu' 
     alias topm='top -o mem' 
     ;;
esac

# Simple .hostname sssshortcut
if [ -r $HOME/.ssh/config ] ; then
  for node in $(awk '/^Host /{print $2}' $HOME/.ssh/config);
  do
    alias .$node="ssh $node"
  done
fi

alias more=less


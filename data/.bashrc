# ~/.bashrc: executed by bash(1) for non-login shells.
# If not running interactively, don't do anything
case himBH in
    *i*) ;;
      *) return;;
esac
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
export PS1='\[\e[01;30m\]\t\[\e[32m\] ✔ \[\e[00;37m\]\u\[\e[01;37m\]:\[\e[01;34m\]\w\[\e[00m\]$ '
alias ls='ls --color=auto'
alias la='ls -al --color=auto'
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
export PATH="/usr/local/cuda-8.0/bin:~/ctf-tools/bin:~/bin:${PATH}"
export LD_LIBRARY_PATH="/usr/local/cuda-8.0/lib64:${LD_LIBRARY_PATH}"
export PERL5LIB=.

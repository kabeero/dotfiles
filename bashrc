# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

#alias ls='ls --group-directories-first'
alias ll='ls -lh'
alias l='ls'
alias mv='mv -i'
alias rm='rm -i'

export VISUAL=vim
export EDITOR=vim

export TERM='xterm-256color'
# export irssi='xterm-256color'
alias irssi='TERM=screen-256color irssi'
#export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
#export PS1='\[\033[01;30m\][\[\033[01;36m\]\w\[\033[01;30m\]]\n\[\033[37m\]\u\[\033[01;30m\]@\[\033[01;36m\]\h \[\033[1;30m\]\$ \[\033[00m\]'
export PS1='\[\033[01;30m\][\[\033[38;5;82m\]\w\[\033[01;30m\]]\n\[\033[37m\]\u\[\033[01;30m\]@\[\033[38;5;82m\]\h \[\033[1;30m\]\$ \[\033[00m\]'

export LM_LICENSE_FILE=50000@poseidon

# this is already set by env-update && source /etc/profile
# export PATH=/usr/local/bin:/usr/bin:/bin:/opt/bin:$PATH


# if [ -f ~/.cadence.bash ]; then
#     echo 'Init Cadence?'
#     read -n 1 -r
#     if [[ $REPLY =~ ^[yY] ]]; then
#         . ~/.cadence.bash
#     fi
# fi

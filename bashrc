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

#lias ls='ls --group-directories-first'
alias lll='ls -lh'
alias ll='ls -1'
alias l='ls'
alias mv='mv -i'
alias rm='rm -i'

export VISUAL=vim
export EDITOR=vim

export TERM='xterm-256color'
alias irssi='TERM=screen-256color irssi'

# default
#export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
# light blue
#export PS1='\[\033[01;30m\][\[\033[01;36m\]\w\[\033[01;30m\]]\n\[\033[37m\]\u\[\033[01;30m\]@\[\033[01;36m\]\h \[\033[1;30m\]\$ \[\033[00m\]'
# green
export PS1='\[\033[01;30m\][\[\033[38;5;82m\]\w\[\033[01;30m\]]\n\[\033[37m\]\u\[\033[01;30m\]@\[\033[38;5;82m\]\h \[\033[1;30m\]\$ \[\033[00m\]'

export LM_LICENSE_FILE=50000@poseidon

export SCIPY_PIL_IMAGE_VIEWER=feh

# this is already set by env-update && source /etc/profile
# export PATH=/usr/local/bin:/usr/bin:/bin:/opt/bin:$PATH

# for /opt/p4v
export PATH=$PATH:/usr/lib64

# for rust / cargo
export PATH=$PATH:/home/kabeero/.cargo/bin

# no dark blue
# LS_COLORS='rs=0:di=1;35:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
#export LS_COLORS

# needs vivid (rust module, installed to /usr/share/vivid/{filetypes.yml,themes}
# molokai , ayu , jellybeans , snazzy 
export LS_COLORS="$(vivid -m 8-bit generate ayu)"

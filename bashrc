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

# need rust , cargo (+path:~/.cargo/bin) , vivid -> /usr/share/vivid/{filetypes.yml,themes/}
# molokai , ayu , jellybeans , snazzy 
#xport LS_COLORS="$(vivid -m 8-bit generate ayu)"

export LS_COLORS="so=0;38;5;16;48;5;203:or=0;38;5;16;48;5;203:ln=0;38;5;203:no=0:di=0;38;5;32:fi=0:*~=0;38;5;248:bd=0;38;5;16;48;5;203:cd=0;38;5;16;48;5;106:ex=1;38;5;203:pi=0;38;5;16;48;5;32:mi=0;38;5;16;48;5;203:*.h=0;38;5;65:*.p=0;38;5;65:*.a=1;38;5;203:*.o=0;38;5;248:*.r=0;38;5;65:*.d=0;38;5;65:*.z=4;38;5;106:*.t=0;38;5;65:*.m=0;38;5;65:*.c=0;38;5;65:*.mn=0;38;5;65:*.md=0;38;5;209:*.pm=0;38;5;65:*.ps=0;38;5;203:*.rs=0;38;5;65:*.sh=0;38;5;65:*.so=1;38;5;203:*.xz=4;38;5;106:*.kt=0;38;5;65:*.rb=0;38;5;65:*.py=0;38;5;65:*.ml=0;38;5;65:*.vb=0;38;5;65:*.as=0;38;5;65:*.cr=0;38;5;65:*.ts=0;38;5;65:*.hs=0;38;5;65:*.ui=0;38;5;209:*.hh=0;38;5;65:*.hi=0;38;5;248:*css=0;38;5;65:*.gz=4;38;5;106:*.nb=0;38;5;65:*.go=0;38;5;65:*.ko=1;38;5;203:*.di=0;38;5;65:*.jl=0;38;5;65:*.cc=0;38;5;65:*.el=0;38;5;65:*.cs=0;38;5;65:*.rm=0;38;5;203:*.pl=0;38;5;65:*.td=0;38;5;65:*.fs=0;38;5;65:*.pp=0;38;5;65:*.ex=0;38;5;65:*.bc=0;38;5;248:*.la=0;38;5;248:*.ll=0;38;5;65:*.7z=4;38;5;106:*.gv=0;38;5;65:*.js=0;38;5;65:*.cp=0;38;5;65:*.bz=4;38;5;106:*.lo=0;38;5;248:*.clj=0;38;5;65:*.xml=0;38;5;209:*.rst=0;38;5;209:*.sty=0;38;5;248:*.com=1;38;5;203:*.bak=0;38;5;248:*.htm=0;38;5;209:*.swf=0;38;5;203:*.nix=0;38;5;209:*.csv=0;38;5;209:*.cfg=0;38;5;209:*.pbm=0;38;5;203:*.doc=0;38;5;203:*.rtf=0;38;5;203:*.xmp=0;38;5;209:*.bib=0;38;5;209:*.exe=1;38;5;203:*.ogg=0;38;5;203:*.kex=0;38;5;203:*.tcl=0;38;5;65:*.mkv=0;38;5;203:*.xlr=0;38;5;203:*.bst=0;38;5;209:*.iso=4;38;5;106:*.mov=0;38;5;203:*.otf=0;38;5;203:*.gif=0;38;5;203:*.ini=0;38;5;209:*.sxw=0;38;5;203:*.tar=4;38;5;106:*.vob=0;38;5;203:*.ppm=0;38;5;203:*.pps=0;38;5;203:*.mid=0;38;5;203:*.bmp=0;38;5;203:*.inl=0;38;5;65:*.cgi=0;38;5;65:*.out=0;38;5;248:*.dox=0;38;5;113:*.ltx=0;38;5;65:*.ics=0;38;5;203:*.mir=0;38;5;65:*.ps1=0;38;5;65:*.exs=0;38;5;65:*.inc=0;38;5;65:*.cxx=0;38;5;65:*.ipp=0;38;5;65:*.jar=4;38;5;106:*.apk=4;38;5;106:*.idx=0;38;5;248:*.arj=4;38;5;106:*.erl=0;38;5;65:*.bz2=4;38;5;106:*.xcf=0;38;5;203:*.odp=0;38;5;203:*.pod=0;38;5;65:*.blg=0;38;5;248:*.zip=4;38;5;106:*.ico=0;38;5;203:*.tmp=0;38;5;248:*.odt=0;38;5;203:*.epp=0;38;5;65:*.rar=4;38;5;106:*.pkg=4;38;5;106:*.mli=0;38;5;65:*.jpg=0;38;5;203:*.pid=0;38;5;248:*.mp3=0;38;5;203:*.ilg=0;38;5;248:*TODO=1:*.svg=0;38;5;203:*.sql=0;38;5;65:*.bcf=0;38;5;248:*hgrc=0;38;5;113:*.wav=0;38;5;203:*.xls=0;38;5;203:*.ppt=0;38;5;203:*.hpp=0;38;5;65:*.wmv=0;38;5;203:*.vim=0;38;5;65:*.deb=4;38;5;106:*.fon=0;38;5;203:*.sbt=0;38;5;65:*.pro=0;38;5;113:*.tex=0;38;5;65:*.png=0;38;5;203:*.swp=0;38;5;248:*.dmg=4;38;5;106:*.fsx=0;38;5;65:*.elm=0;38;5;65:*.m4v=0;38;5;203:*.cpp=0;38;5;65:*.c++=0;38;5;65:*.def=0;38;5;65:*.vcd=4;38;5;106:*.hxx=0;38;5;65:*.bat=1;38;5;203:*.aif=0;38;5;203:*.sxi=0;38;5;203:*.tml=0;38;5;209:*.htc=0;38;5;65:*.h++=0;38;5;65:*.pas=0;38;5;65:*.pyc=0;38;5;248:*.dll=1;38;5;203:*.bin=4;38;5;106:*.pdf=0;38;5;203:*.csx=0;38;5;65:*.bsh=0;38;5;65:*.git=0;38;5;248:*.bag=4;38;5;106:*.tif=0;38;5;203:*.mp4=0;38;5;203:*.img=4;38;5;106:*.php=0;38;5;65:*.mpg=0;38;5;203:*.gvy=0;38;5;65:*.wma=0;38;5;203:*.fsi=0;38;5;65:*.dot=0;38;5;65:*.pgm=0;38;5;203:*.ods=0;38;5;203:*.avi=0;38;5;203:*.dpr=0;38;5;65:*.fnt=0;38;5;203:*.tgz=4;38;5;106:*.txt=0;38;5;209:*.ind=0;38;5;248:*.flv=0;38;5;203:*.aux=0;38;5;248:*.fls=0;38;5;248:*.awk=0;38;5;65:*.asa=0;38;5;65:*.lua=0;38;5;65:*.ttf=0;38;5;203:*.zsh=0;38;5;65:*.toc=0;38;5;248:*.log=0;38;5;248:*.yml=0;38;5;209:*.rpm=4;38;5;106:*.kts=0;38;5;65:*.tsx=0;38;5;65:*.bbl=0;38;5;248:*.tbz=4;38;5;106:*.pptx=0;38;5;203:*.less=0;38;5;65:*.rlib=0;38;5;248:*.xlsx=0;38;5;203:*.docx=0;38;5;203:*.flac=0;38;5;203:*.conf=0;38;5;209:*.dart=0;38;5;65:*.lisp=0;38;5;65:*.orig=0;38;5;248:*.jpeg=0;38;5;203:*.lock=0;38;5;248:*.purs=0;38;5;65:*.json=0;38;5;209:*.psm1=0;38;5;65:*.toml=0;38;5;209:*.yaml=0;38;5;209:*.h264=0;38;5;203:*.html=0;38;5;209:*.hgrc=0;38;5;113:*.diff=0;38;5;65:*.fish=0;38;5;65:*.make=0;38;5;113:*.tbz2=4;38;5;106:*.epub=0;38;5;203:*.java=0;38;5;65:*.mpeg=0;38;5;203:*.psd1=0;38;5;65:*.bash=0;38;5;65:*.cache=0;38;5;248:*.class=0;38;5;248:*.mdown=0;38;5;209:*.xhtml=0;38;5;209:*passwd=0;38;5;209:*.swift=0;38;5;65:*.dyn_o=0;38;5;248:*.toast=4;38;5;106:*.cabal=0;38;5;65:*.scala=0;38;5;65:*.patch=0;38;5;65:*README=0;38;5;16;48;5;209:*.cmake=0;38;5;113:*.shtml=0;38;5;209:*shadow=0;38;5;209:*.ipynb=0;38;5;65:*.matlab=0;38;5;65:*.gradle=0;38;5;65:*TODO.md=1:*.flake8=0;38;5;113:*.groovy=0;38;5;65:*COPYING=0;38;5;241:*.ignore=0;38;5;113:*.dyn_hi=0;38;5;248:*LICENSE=0;38;5;241:*.config=0;38;5;209:*INSTALL=0;38;5;16;48;5;209:*.desktop=0;38;5;209:*TODO.txt=1:*Makefile=0;38;5;113:*setup.py=0;38;5;113:*Doxyfile=0;38;5;113:*.gemspec=0;38;5;113:*README.md=0;38;5;16;48;5;209:*COPYRIGHT=0;38;5;241:*.fdignore=0;38;5;113:*.cmake.in=0;38;5;113:*.kdevelop=0;38;5;113:*.markdown=0;38;5;209:*.rgignore=0;38;5;113:*configure=0;38;5;113:*.gitignore=0;38;5;113:*Dockerfile=0;38;5;209:*SConstruct=0;38;5;113:*.gitconfig=0;38;5;113:*CODEOWNERS=0;38;5;113:*README.txt=0;38;5;16;48;5;209:*.scons_opt=0;38;5;248:*SConscript=0;38;5;113:*INSTALL.md=0;38;5;16;48;5;209:*LICENSE-MIT=0;38;5;241:*Makefile.in=0;38;5;248:*Makefile.am=0;38;5;113:*.gitmodules=0;38;5;113:*.travis.yml=0;38;5;65:*.synctex.gz=0;38;5;248:*MANIFEST.in=0;38;5;113:*.fdb_latexmk=0;38;5;248:*.applescript=0;38;5;65:*appveyor.yml=0;38;5;65:*CONTRIBUTORS=0;38;5;16;48;5;209:*configure.ac=0;38;5;113:*.clang-format=0;38;5;113:*LICENSE-APACHE=0;38;5;241:*CMakeCache.txt=0;38;5;248:*.gitattributes=0;38;5;113:*INSTALL.md.txt=0;38;5;16;48;5;209:*CMakeLists.txt=0;38;5;113:*CONTRIBUTORS.md=0;38;5;16;48;5;209:*requirements.txt=0;38;5;113:*.sconsign.dblite=0;38;5;248:*CONTRIBUTORS.txt=0;38;5;16;48;5;209:*package-lock.json=0;38;5;248"

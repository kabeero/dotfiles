if status is-interactive
    alias ls='exa'
    alias ll='ls -l'
    alias l1='ls -1'
    alias l='l1'
	alias l='ls'
	
	# pip --user paths
	#set -Ux PYTHONPATH (python -c "import site; print(site.USER_SITE)")
	
	# gentoo
	echo -e "\x1b[38;2;0;112;248m"(date +%c)"\x1b[0m"
	
	# macos
    #pfetch
    #echo -e "\033[0;32m"(date +%c)"\x1b[0m"
    
    # starship init
    #source (/usr/local/bin/starship init fish --print-full-init | psub)
end

if status is-interactive
	#echo -e "\e[95m"(date +%c)"\e[97m"
	#echo -e "\x1b[38;2;0;112;248m"(date +%X%x)"\x1b[0m"
	echo -e "\x1b[38;2;0;112;248m"(date +%c)"\x1b[0m"
	alias ls='exa'
	alias l='ls'
	#set -Ux PYTHONPATH (python -c "import site; print(site.USER_SITE)")
end

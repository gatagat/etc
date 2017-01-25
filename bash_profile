function log_bash_profile ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/.bash_profile]: $1"
}

log_bash_profile "Start"

log_bash_profile "Sourcing .profile"
[ -e ~/.profile ] && source ~/.profile

log_bash_profile "Bash stuff"
shopt -s checkwinsize
shopt -s histappend
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"

log_bash_profile "Sourcing .bashrc"
[ -e ~/.bashrc ] && source ~/.bashrc

log_bash_profile "Done"

unset -f log_bash_profile

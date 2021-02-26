function log_bash_profile ()
{
	echo "$(date +%Y%m%d%H%M%S) [~/.bash_profile]: $1"
}

log_bash_profile "Start"

log_bash_profile "Sourcing .profile"
[ -e ~/.profile ] && source ~/.profile

log_bash_profile "Sourcing .bashrc"
[ -e ~/.bashrc ] && source ~/.bashrc

log_bash_profile "Done"

unset -f log_bash_profile

function log_profile
{
	echo "$(date +%Y%m%d%H%M%S) [~/.profile]: $1"
}

log_profile "Start"

uname=`uname`
if [ "$uname" != "Linux" ]; then
	log_profile "System $uname is not setup"
fi
[ -d ~/bin ] && PATH=~/bin:$PATH
[ -d ~/.local/bin ] && PATH=~/.local/bin:$PATH
export PATH

log_profile "Done"

source "$HOME/.rye/env"

unset -f log_profile
unset uname

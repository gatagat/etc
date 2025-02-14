# Stop here without any output if non-interactive, e.g., important for:
# `ssh host /bin/true`, or `git clone`, ...
if [[ "$-" != *i* ]]; then
	#log_bashrc "Non-interactive session, quitting"
	return
fi

LOG_SCRIPT=~/.bashrc
function log_bashrc
{
	echo "$(date +%Y%m%d%H%M%S) [$LOG_SCRIPT]: $1"
}

log_bashrc "Start"

uname=$(uname)
if [ "$uname" != "Darwin" -a "$uname" != "Linux" ]; then
	echo >&2 "$0: Unknown OS encountered: $uname"
fi

if [ "$uname" == "Darwin" ]; then
	log_bashrc "Bash completion on Darwin"
	if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
		source /opt/local/etc/profile.d/bash_completion.sh
	fi
fi
log_bashrc "Sourcing local bash completion scripts"
for file in ~/etc/bash_completion.d/*; do
	source $file
done

log_bashrc "Sourcing local bash setup scripts"
for file in ~/etc/bashrc.d/*; do
	source $file
done

log_bashrc "Done"

unset -f log_bashrc
unset uname

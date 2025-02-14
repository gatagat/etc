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
if [ "$uname" != "Linux" ]; then
	log_profile "System $uname is not setup"
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

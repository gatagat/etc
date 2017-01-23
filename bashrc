function log ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/.bashrc]: $1"
}

log "Start"

# Please do shut up if non-interactive, also if `ssh host /bin/true`, or
# `git clone`, ...
if [[ "$-" != *i* ]]; then
	log "Non-interactive session, quitting"
	return
fi

PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "

log "Done"

unset log

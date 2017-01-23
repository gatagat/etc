function log_bashrc ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/.bashrc]: $1"
}

log_bashrc "Start"

# Please do shut up if non-interactive, also if `ssh host /bin/true`, or
# `git clone`, ...
if [[ "$-" != *i* ]]; then
	log_bashrc "Non-interactive session, quitting"
	return
fi

log_bashrc "Setting aliases"
alias ls='ls --color=auto'
alias ll='ls --color=auto -l'
alias grep='grep --color=auto'

log_bashrc "Setting PS1"
PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "

# bash-completion itself is sourced by the system.
log_bashrc "Bash completion"
if [ -e /etc/bash_completion.d/git ]; then
    source /etc/bash_completion.d/git
fi
for file in ~/etc/bash_completion.d/*; do
	source $file
done

log_bashrc "Done"

unset -f log_bashrc

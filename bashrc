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

# bash-completion itself is sourced by the system.
log_bashrc "Bash completion"
for file in ~/etc/bash_completion.d/*; do
	log_bashrc "Sourcing $file"
	source $file
done

if declare -f __git_ps1 > /dev/null; then # do we have __git_ps1?
	log_bashrc "Setting fancy git-enabled PS1"
	GIT_PS1_SHOWDIRTYSTATE=1
	GIT_PS1_SHOWUNTRACKEDFILES=1
	PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\$(__git_ps1 '[%s]') \$\[\033[00m\] "
else
	log_bashrc "Setting fancy PS1"
	PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "
fi
export PS1

log_bashrc "Done"

unset -f log_bashrc

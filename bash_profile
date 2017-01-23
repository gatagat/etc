function log ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/.bash_profile]: $1"
}

log "Start"
log "Sourcing .profile"
[ -e ~/.profile ] && source ~/.profile
function log ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/.bash_profile]: $1"
}

log "Bash stuff"
shopt -s checkwinsize
shopt -s histappend
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"
alias ls='ls --color=auto'
alias ll='ls --color=auto -l'
alias grep='grep --color=auto'
# Bash completion for git, bash-completion itself is sourced by the system.
if [ -e /etc/bash_completion.d/git ]; then
    source /etc/bash_completion.d/git
fi
for file in ~/etc/bash_completion.d/*; do
	source $file
done
log "Bash-stuff done"

log "Sourcing .bashrc"
[ -e ~/.bashrc ] && source ~/.bashrc
function log ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/.bash_profile]: $1"
}

log "Done"

unset log

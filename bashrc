function log_bashrc ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/.bashrc]: $1"
}

log_bashrc "Start"
uname=$(uname)

# Please do shut up if non-interactive, also if `ssh host /bin/true`, or
# `git clone`, ...
if [[ "$-" != *i* ]]; then
	log_bashrc "Non-interactive session, quitting"
	return
fi

if [ "$uname" == "Darwin" ]; then
	export EDITOR=/opt/local/bin/vim
fi

log_bashrc "Setting aliases"
if [ "$uname" == "Darwin" ]; then
	#alias ls='ls --color=auto' -- cannot use this with bsd/mac ls, use CLICOLOR instead
	export CLICOLOR=1
	alias ll='ls -l'
	alias apache2ctl='sudo /opt/local/apache2/bin/apachectl'
elif [ "$uname" == "Linux" ]; then
	alias ls='ls --color=auto'
	alias ll='ls --color=auto -l'
else
	echo >&2 "$0: Unknown OS encountered: $uname"
fi
alias grep='grep --color=auto'

# bash-completion itself is sourced by the system.
log_bashrc "Bash completion"
if [ "$uname" == "Darwin" ]; then
	if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
		source /opt/local/etc/profile.d/bash_completion.sh
	fi
fi
for file in ~/etc/bash_completion.d/*; do
	log_bashrc "Sourcing $file"
	source $file
done

if declare -f __git_ps1 > /dev/null; then # do we have __git_ps1?
	log_bashrc "Setting fancy git-enabled PS1"
	GIT_PS1_SHOWDIRTYSTATE=1
	GIT_PS1_SHOWUNTRACKEDFILES=1
	PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\$(__git_ps1 '\[\033[01;33m\] %s\[\033[01;34m\]' 2>/dev/null) \$\[\033[00m\] "
else
	log_bashrc "Setting fancy PS1"
	PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "
fi
export PS1

log_bashrc "Setting up history and journaling"
shopt -s checkwinsize
shopt -s histappend
shopt -s globstar 2> /dev/null # enables ** to recurse all directories
bind "set completion-ignore-case on" # case-insensitive completion
bind "set mark-symlinked-directories on" # add / to completed symlink directories
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTFILE=$HOME/.bash_history
export COMMAND_JOURNAL_FILE=$HOME/.command_journals/$(hostname).tsv
log_bashrc "Journaling to $COMMAND_JOURNAL_FILE"
mkdir -p $(dirname $COMMAND_JOURNAL_FILE) >/dev/null && true
export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTTIMEFORMAT="%Y%m%d%H%M%S "
command_journal_append()
{
	local rv=$?
	if [ "$rv" -ne 0 ]; then
		return
	fi
	[[ $(history 1) =~ ^\ *[0-9]+\ +([0-9]+)\ +(.*)$ ]]
	local date="${BASH_REMATCH[1]}"
	local cmd="${BASH_REMATCH[2]}"
	if [ "$cmd" != "$COMMAND_JOURNAL_LAST" ]
	then
		echo -e "$date\t$cmd" >> $COMMAND_JOURNAL_FILE
		export COMMAND_JOURNAL_LAST="$cmd"
	fi
}
# history -c = clear history in the current shell
# history -w = overwrite history file
# history -a = append to the history file
# history -r = read the history file
PROMPT_COMMAND="command_journal_append;history -a;$PROMPT_COMMAND"

log_bashrc "Done"

unset -f log_bashrc
unset uname

function log_bashrc ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/.bashrc]: $1"
}

uname=$(uname)

# Please do shut up if non-interactive, also if `ssh host /bin/true`, or
# `git clone`, ...
if [[ "$-" != *i* ]]; then
	#log_bashrc "Non-interactive session, quitting"
	return
fi
log_bashrc "Start"

if [ "$uname" == "Darwin" ]; then
	export EDITOR=/opt/local/bin/vim
fi

log_bashrc "Setting aliases"
export WORKON_HOME="$HOME/.virtualenvs"
if [ "$uname" == "Darwin" ]; then
	#alias ls='ls --color=auto' -- cannot use this with bsd/mac ls, use CLICOLOR instead
	export CLICOLOR=1
	alias ll='ls -l'
	alias apache2ctl='sudo /opt/local/apache2/bin/apachectl'
	source /opt/local/bin/virtualenvwrapper.sh-3.8
elif [ "$uname" == "Linux" ]; then
	alias ls='ls --color=auto'
	alias ll='ls --color=auto -l'
	if [ ! -z `which sbatch` ]; then
		export SLURM_TIME_FORMAT="%y.%m.%d-%H:%M:%S"
		export SQUEUE_FORMAT="%%10i %.6Q %.13j %.10u %.2t %.10M %.4P %.3q %.17S %.10l %.2D %.2C %4m %12R %b"
		alias sqa='squeue -S "-p,t,j"'
		alias sqar='sqa -t R'
		alias sq='sqa -u $USER'
		alias sqr='sqa -u $USER -t R'
		alias sra='sreport cluster AccountUtilizationByUser'
		alias sr='sra | grep --color=never $USER'
		alias sa='sacct --format="Start,User%7,JobID%-7,JobName%14,ExitCode%5,Timelimit,Elapsed,ReqMem%5,MaxRss,MaxDiskRead,MaxDiskWrite,AllocCPUS%3"'
		alias sqos='sacctmgr list qos format=name,prio,grptres%30,maxtres%30,maxwall'
		alias sjobinfo='sacct -o jobid,account,user%15,submit,start,end,elapsed,exitcode,reqtres%40,nodelist,ntasks,state%20,timelimit,submit -j'
		# scontrol update jobid=$1 QOS=short
	fi

	source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
else
	echo >&2 "$0: Unknown OS encountered: $uname"
fi
alias grep='grep --color=auto'
export LS_COLORS='pi=7:so=7:bd=7:cd=7:di=0;94:fi=0:ex=0;32:ln=0;94:mi=0;31'

# bash-completion itself is sourced by the system.
log_bashrc "Bash completion"
if [ "$uname" == "Darwin" ]; then
	if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
		source /opt/local/etc/profile.d/bash_completion.sh
	fi
else
	# Sourcing bash completion is required for mkvirtualenv on labe
	if ! shopt -oq posix; then
		if [ -f /usr/share/bash-completion/bash_completion ]; then
			. /usr/share/bash-completion/bash_completion
		elif [ -f /etc/bash_completion ]; then
			. /etc/bash_completion
		fi
	fi
fi
for file in ~/etc/bash_completion.d/*; do
	log_bashrc "Sourcing $file"
	source $file
done

# for i in {0..255}; do     printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"; done
if declare -f __git_ps1 > /dev/null; then # do we have __git_ps1?
	log_bashrc "Setting fancy git-enabled PS1"
	GIT_PS1_SHOWDIRTYSTATE=1
	GIT_PS1_SHOWUNTRACKEDFILES=1
	PS1="\[\033[38;5;28m\]\u@\h\[\033[38;5;20m\] \w\$(__git_ps1 '\[\033[38;5;220m\] %s\[\033[38;5;20m\]' 2>/dev/null) \$\[\033[00m\] "
else
	log_bashrc "Setting fancy PS1"
	PS1="\[\033[38;5;28m\]\u@\h\[\033[38;5;20m\] \w \$\[\033[00m\] "
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

if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

log_bashrc "Done"

unset -f log_bashrc
unset uname

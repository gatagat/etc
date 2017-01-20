echo "Running ~/.profile - Start $(date)"
if [ "`type -t module`" == "function" ]; then
    # XXX: loading minimal is needed in order to have the modules setup inside
    # login shells run by screen.
echo "Running ~/.profile - load minimal $(date)"
    module load minimal

    # Get rid of the weird stuff.
echo "Running ~/.profile - unloads $(date)"
    module unload aliases
    module unload dot
    module unload term
    # XXX: unload as they are inactive when using eb
    module unload impimba-1
    module unload ogrt/0.3.0-2-g28daf5

echo "Running ~/.profile - load gridengine $(date)"
    module load gridengine/2011.11
fi
echo "Running ~/.profile - Module cleanup done $(date)"

# .profile is used for all shells including sh used for scripts on the cluster,
# this block protects the part that is bash-specific.
case "$0" in -bash|bash|*/bash)
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
    PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "
    ;;
esac
echo "Running ~/.profile - Bash-specific things done $(date)"

# Setup EasyBuild
if [ -e /biosw/debian7-x86_64/easybuild/setup-eb.sh ]; then
    #source /biosw/debian7-x86_64/easybuild/setup-eb.sh
export EASYBUILD_MODULES_TOOL=Lmod
export EASYBUILD_BUILDPATH=/tmp
export EASYBUILD_ROBOT_PATHS=/biosw/debian7-x86_64/easybuild/easybuild-easyconfigs
export EASYBUILD_IGNORE_OSDEPS=1
export EASYBUILD_PREFIX=/biosw/debian7-x86_64/easybuild/20160610

echo "Running ~/.profile - modules.sh $(date)"
source /etc/profile.d/modules.sh
#export EASYBUILD_BUILDPATH=/dev/shm/$USER

echo "Running ~/.profile - use $(date)"
module use /biosw/debian7-x86_64/easybuild/20160610/modules/all

echo "Running ~/.profile - unuses $(date)"
module unuse /biosw/modules/modulefiles/biosw
module unuse /biosw/modules/modulefiles/devel
module unuse /biosw/modules/modulefiles/em
module unuse /biosw/modules/modulefiles/groups
module unuse /biosw/modules/modulefiles/hadoop
module unuse /biosw/modules/modulefiles/motif
module unuse /biosw/modules/modulefiles/msa
module unuse /biosw/modules/modulefiles/multimedia /biosw/modules/modulefiles/ngs
module unuse /biosw/modules/modulefiles/structure_md

echo "Running ~/.profile - load eb $(date)"
module load EasyBuild
fi
echo "Running ~/.profile - Setup eb done $(date)"

# Matlab should not clutter my HOME!
export MATLAB_LOG_DIR=/tmp

PATH=~/bin:$PATH

echo "Running ~/.profile - Done $(date)"

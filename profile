function log_profile ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/.profile]: $1"
}

log_profile "Start"
if [ -d '/biosw' ]; then # XXX: hackish test for IMP/IMBA cluster
    # A predefined set of modules gets loaded in /etc/profile, correct it here.
    if [ "`type -t module`" == "function" ]; then
        # Get rid of the weird stuff.
        log_profile "Unloads"
        module unload aliases
        module unload dot
        module unload term
        # XXX: unload as they are inactive when using eb
        module unload impimba-1
        module unload ogrt/0.3.0-2-g28daf5
        log_profile "Module cleanup done"
    fi

    # Switch to EasyBuild modules
    if [ -e ~/.easybuild/enable ]; then
	log_profile "Setup eb modules"
        #source /biosw/debian7-x86_64/easybuild/setup-eb.sh
        export EASYBUILD_MODULES_TOOL=Lmod
        export EASYBUILD_BUILDPATH=/tmp
        export EASYBUILD_ROBOT_PATHS=/biosw/debian7-x86_64/easybuild/easybuild-easyconfigs
        export EASYBUILD_IGNORE_OSDEPS=1
        export EASYBUILD_PREFIX=/biosw/debian7-x86_64/easybuild/20160610

        log_profile "modules.sh"
        source /etc/profile.d/modules.sh
        #export EASYBUILD_BUILDPATH=/dev/shm/$USER

        log_profile "use"
        module use /biosw/debian7-x86_64/easybuild/20160610/modules/all

        log_profile "unuses"
        module unuse /biosw/modules/modulefiles/biosw
        module unuse /biosw/modules/modulefiles/devel
        module unuse /biosw/modules/modulefiles/em
        module unuse /biosw/modules/modulefiles/groups
        module unuse /biosw/modules/modulefiles/hadoop
        module unuse /biosw/modules/modulefiles/motif
        module unuse /biosw/modules/modulefiles/msa
        module unuse /biosw/modules/modulefiles/multimedia /biosw/modules/modulefiles/ngs
        module unuse /biosw/modules/modulefiles/structure_md
        log_profile "Setup eb modules done"
    fi
fi

# Matlab should not clutter my HOME!
export MATLAB_LOG_DIR=/tmp

PATH=~/bin:$PATH
if [ "$uname" == "Darwin" ]; then
    PATH="/opt/local/bin:/opt/local/sbin:$PATH"
    PATH="/Users/kazmar/node_modules/instant-markdown-d/:$PATH"

    # Setting PATH for Python 2.7
    # The original version is saved in .profile.pysave
    PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
fi
export PATH

log_profile "Done"

unset -f log_profile

function log_profile ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/.profile]: $1"
}

log_profile "Start"
if [ "`type -t module`" == "function" ]; then
    # Get rid of the weird stuff.
    log_profile "Unloads"
    module unload aliases
    module unload dot
    module unload term
    # XXX: unload as they are inactive when using eb
    module unload impimba-1
    module unload ogrt/0.3.0-2-g28daf5
fi
log_profile "Module cleanup done"

# Setup EasyBuild
log_profile "Setup eb"
if [ -e /biosw/debian7-x86_64/easybuild/setup-eb.sh ]; then
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

log_profile "load eb"
module load EasyBuild
fi
log_profile "Setup eb done"

# Matlab should not clutter my HOME!
export MATLAB_LOG_DIR=/tmp

PATH=~/bin:$PATH

log_profile "Done"

unset -f log_profile

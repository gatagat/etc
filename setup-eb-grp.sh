GRP=$1

function log_setup_eb_grp_sh ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/etc/setup-eb-grp.sh $GRP]: $1"
}

source ~/etc/setup-modules-grp.sh "$GRP"

ml load EasyBuild/3.0.2

log_setup_eb_grp_sh "Setting up environment variables."
#export PYTHONPATH=$PYTHONPATH:$HOME/eb-mns
#export EASYBUILD_MODULE_NAMING_SCHEME=ExampleModuleNamingScheme
export EASYBUILD_ROBOT_PATHS=~/eb:$EASYBUILD_ROBOT_PATHS
#export EASYBUILD_INCLUDE_EASYBLOCKS=~/eb-blocks
export EASYBUILD_PREFIX=/groups/$GRP/software/.easybuild/
export EASYBUILD_INSTALLPATH_SOFTWARE=/groups/$GRP/software/
export EASYBUILD_INSTALLPATH_MODULES=/groups/$GRP/software/modules/

unset -f log_setup_eb_grp_sh

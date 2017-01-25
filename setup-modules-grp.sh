GRP=$1

function log_setup_modules_grp_sh ()
{
	echo >&2 "$(date +%y%m%d%h%m%s) [~/etc/setup-modules-grp.sh $grp]: $1"
}

log_setup_modules_grp_sh "Looking for modules to unuse."
MODULEPATH_TO_REMOVE=`echo $MODULEPATH | awk -vRS=: -vFS=/ -vgrp=$GRP '
	($2 == "groups" && $3 != grp && $4 == "software" && $5 == "modules")' | xargs`
if [ ! -z "$MODULEPATH_TO_REMOVE" ]; then
	log_setup_modules_grp_sh "module unuse $MODULEPATH_TO_REMOVE"
	module unuse $MODULEPATH_TO_REMOVE
fi
log_setup_modules_grp_sh "module use /groups/$GRP/software/modules/all"
module use /groups/$GRP/software/modules/all

unset -f log_setup_modules_grp_sh

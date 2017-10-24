GRP=$1

function log_setup_eb_grp_sh ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/etc/setup-eb-grp.sh $GRP]: $1"
}

if [ -d /biosw ]; then
	source ~/etc/setup-modules-grp.sh "$GRP"
	ml load EasyBuild/3.1.0
	log_setup_eb_grp_sh "Setting up environment variables."
	#export PYTHONPATH=$PYTHONPATH:$HOME/eb-mns
	#export EASYBUILD_MODULE_NAMING_SCHEME=ExampleModuleNamingScheme
	export EASYBUILD_MODULES_TOOL=Lmod
	export EASYBUILD_BUILDPATH=/tmp
	export EASYBUILD_ROBOT_PATHS=~/eb:/biosw/debian7-x86_64/easybuild/easybuild-easyconfigs:$EASYBUILD_ROBOT_PATHS
	#export EASYBUILD_INCLUDE_EASYBLOCKS=~/eb-blocks
	export EASYBUILD_IGNORE_OSDEPS=1
	export EASYBUILD_PREFIX=/groups/$GRP/software/.easybuild/
	export EASYBUILD_INSTALLPATH_SOFTWARE=/groups/$GRP/software/
	export EASYBUILD_INSTALLPATH_MODULES=/groups/$GRP/software/modules/
elif [ "$IMPIMBA_MACHINE_NAME" == "IMPIMBA-2" ]; then
	EB_EDITION=171020
	if [ "$EASYBUILD_PREFIX" != "/software/$EB_EDITION" ]; then
		echo >&2 "Expected eb module tree at /software/$EB_EDITION. Quitting."
	else
		ml purge
		ml load build-env/$EB_EDITION
		ml load easybuild/3.4.1
		module use "/groups/$GRP/software/$EB_EDITION-ii2/modules/all"
		log_setup_eb_grp_sh "Setting up environment variables."
		export EASYBUILD_ROBOT_PATHS=/software/$EB_EDITION/ebfiles_repo/:/groups/pauli/kazmar/projs/eb/ii2/easybuild/easyconfigs
		export EASYBUILD_BUILDPATH=/tmp
		export EASYBUILD_PREFIX=/groups/$GRP/software/$EB_EDITION-ii2/
		export EASYBUILD_GROUP_WRITABLE_INSTALLDIR=${GRP}.GRP
		newgrp ${GRP}.GRP
	fi
	unset EB_EDITION
else
	echo >&2 "Unknown system."
fi

unset -f log_setup_eb_grp_sh

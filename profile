function log_profile ()
{
	if [ "$(hostname)" == "labe" -o "$(hostname)" == "donau" -o "$(hostname)" == "odra" ]; then
		true # On ubuntu any messages printed from .profile trigger an annoying
		     # error message box.
	else
		echo >&2 "`date +%Y%m%d%H%M%S` [~/.profile]: $1"
	fi
}

uname=`uname`
hostname=`hostname`
log_profile "Start"

# Matlab should not clutter my HOME!
export MATLAB_LOG_DIR=/tmp

if [ -d /biosw ]; then # XXX: hackish test for IMP/IMBA cluster
	log_profile "System: IMPIMBA-1"
	# A predefined set of modules gets loaded in /etc/profile, correct it here.
	if [ "`type -t module`" == "function" ]; then
		# Get rid of the weird stuff.
		log_profile "Unloads"
		module unload aliases
		module unload dot
		module unload term
		# XXX: unload as they are inactive when using eb
		module unload impimba-1
	fi
	if [ "`echo $hostname | cut -f1-3 -d-`" == "impimba-1-login" -a \
			-e ~/.easybuild/enable ]; then
		if [ -e $HOME/etc/modules ]; then
			log_profile "Load basic modules"
			module use $HOME/etc/modules
			ml load git/2.8.0-GCC-4.9.3-2.25
			ml load Python/2.7.11-foss-2016a
			ml load Vim/8.0.069-foss-2016a-noX-Python-2.7
			ml load pycodestyle/2.2.0-foss-2016a-Python-2.7.11
			ml load pyflakes/1.5.0-foss-2016a-Python-2.7.11
			ml load universal-ctags/c27e1a5-foss-2016a
		fi
	fi
elif [ "$IMPIMBA_MACHINE_NAME" == "IMPIMBA-2" ]; then
	log_profile "System: IMPIMBA-2"
	export LMOD_TRACING=no #yes
	export LMOD_CACHED_LOADS=no
	if [ "`echo $hostname | cut -f1 -d-`" == "login" ]; then
		log_profile "Load basic modules"
		ml load build-env/171020
		if [ -e $HOME/etc/modules ]; then
			module use $HOME/etc/modules
			#ml load python/2.7.13-foss-2017a
			ml load vim/8.0.586-foss-2017a-nox-python-2.7
			ml load pycodestyle/2.3.1-foss-2017a-python-2.7.13
			ml load pyflakes/1.6.0-foss-2017a-python-2.7.13
			ml load universal-ctags/924c0ab-foss-2017a
		fi
	fi
elif [ "$uname" == "Darwin" ]; then
	log_profile "System: MacOSX"
	PATH="/opt/local/bin:/opt/local/sbin:$PATH"
	PATH="/Users/kazmar/node_modules/instant-markdown-d/:$PATH"
	# Required on the nbm-imp-55
	PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH"
	export LC_ALL="en_US.UTF-8"
	export LANG="en_US.UTF-8"
	# CUDA
	export CUDA_HOME=/usr/local/cuda
	export DYLD_LIBRARY_PATH=$CUDA_HOME/lib:$DYLD_LIBRARY_PATH
	export PATH=$CUDA_HOME/bin:$PATH
	export PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
	export PATH="/Users/kazmar/projs/flutter/bin:$PATH"
elif [ "$hostname" == "labe" ]; then
	log_profile "System: labe"
	#stty -ixon
	export PATH=/opt/rclone:$PATH
	export PATH=/opt/StorageExplorer-linux-x64:$PATH
else
	log_profile "System: unknown"
fi
PATH=~/bin:$PATH
export PATH

log_profile "Done"

unset -f log_profile
unset uname

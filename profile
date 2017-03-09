function log_profile ()
{
	echo >&2 "$(date +%Y%m%d%H%M%S) [~/.profile]: $1"
}

uname=$(uname)
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
	fi
	if [ -e ~/.easybuild/enable ]; then
		log_profile "Load basic modules"
		module use /home/imp/kazmar/etc/modules
		ml load screen/4.5.1
		ml load git/2.8.0-GCC-4.9.3-2.25
		ml load Python/2.7.11-foss-2016a
		ml load Vim/8.0.069-foss-2016a-noX-Python-2.7
		ml load pycodestyle/2.2.0-foss-2016a-Python-2.7.11
		ml load pyflakes/1.5.0-foss-2016a-Python-2.7.11
		ml load universal-ctags/c27e1a5-foss-2016a
	fi
fi

# Matlab should not clutter my HOME!
export MATLAB_LOG_DIR=/tmp

PATH=~/bin:$PATH
if [ "$uname" == "Darwin" ]; then
	PATH="/opt/local/bin:/opt/local/sbin:$PATH"
	PATH="/Users/kazmar/node_modules/instant-markdown-d/:$PATH"
	# Required on the nbm-imp-55
	PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH"
	export LC_ALL="en_US.UTF-8"
	export LANG="en_US.UTF-8"
fi
export PATH

log_profile "Done"

unset -f log_profile
unset uname

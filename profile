function log_profile ()
{
	echo "$(date +%Y%m%d%H%M%S) [~/.profile]: $1"
}

uname=`uname`
hostname=`hostname`
log_profile "Start"

# Matlab should not clutter my HOME!
export MATLAB_LOG_DIR=/tmp

if [ "$uname" == "Darwin" ]; then
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
	export PATH="$HOME/.jenv/bin:$PATH"
	eval "`jenv init -`"
else
	log_profile "System: unknown"
fi
[ -d ~/bin ] && PATH=~/bin:$PATH
[ -d ~/.local/bin ] && PATH=~/.local/bin:$PATH
export PATH

log_profile "Done"

unset -f log_profile
unset uname

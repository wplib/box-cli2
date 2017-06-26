#!/usr/bin/env bash
#
# Command: box install <installable>
# File: install.sh
#

installable="${BOXCLI_COMMAND_DIR}/installables/install-$1.sh"
if [ ! -f "${installable}" ] ; then
	stdErr "$1 is not a valid installable."
else 
	stdOut "Installing $1..."
	source "${installable}"	
fi	
#
# Command: box vm list
#

if isSwitch "running" ; then
    box vm running
else
    vboxmanage list vms
fi

setQuiet
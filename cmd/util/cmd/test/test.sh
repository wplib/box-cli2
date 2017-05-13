#
# Command: box util test [<arg>]
#

if cat foo 2>&1 >/dev/null; then 
	echo "No foo!"
else
	echo "We have foo!"
fi	
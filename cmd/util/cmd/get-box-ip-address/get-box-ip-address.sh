#
# Command: box util get-box-ip-address
#
# @TODO generate IP address file if not exists. 
# @TODO box util read-box-ip-address should be raw, no creation
# @SEE http://stackoverflow.com/questions/8988824/generating-random-number-between-1-and-10-in-bash-shell-script
#

ip_address="$(box util read-project-file ".box.ip_address")" 

if isEmpty "${ip_address}" ; then 
	ip_address=""
	project_dir="$(box util find-project-dir)"
	ip_address="$(cat "${project_dir}/IP")"
fi

if isEmpty "${ip_address}" ; then 
	echo "IP address not configured."
	exit
fi

echo "${ip_address}"
exit


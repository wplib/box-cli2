#
# Command: box util get-box-ip-address
#

ip_address="$(box util read-project-file ".box.ip_address")" 

if [ "null" == "${ip_address}" ]; then 
	ip_address=""
	project_dir="$(box util find-project-dir)"
	ip_address="$(cat "${project_dir}/IP")"
fi

if [ "" == "${ip_address}" ]; then 
	echo "IP address not configured."
	exit
fi

echo "${ip_address}"
exit


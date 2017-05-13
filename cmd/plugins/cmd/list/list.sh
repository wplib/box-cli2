#
# Command: box plugins list
# 

plugins_dir="$(box util get-content-dir)/plugins"
for plugin in $plugins_dir/* ; do
	plugin_slug=""
	for plugin_file in "${plugin}"/*.php ; do
		while IFS='' read -r line || [[ -n "$line" ]]; do
		    if [[ "${line}" =~ "Plugin Name:" ]] ; then
				plugin_slug="$(basename "${plugin}")/$(basename "${plugin_file}")"
		    	break
		    fi
		done < "${plugin_file}"		
	    if [ -n "${plugin_slug}" ] ; then
			continue
	    fi
	done
    if [ -n "${plugin_slug}" ] ; then
		echo "${plugin_slug}"
    fi
done
exit


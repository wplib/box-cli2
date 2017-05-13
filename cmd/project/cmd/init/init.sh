#
# Command: box project init <project_name>
#

if noArgsPassed ; then
	stdErr "No project name passed."
	exit
fi

project_name="$1"

project_file="$(pwd)/project.json"

if hasProjectFile ; then 
	stdErr "Current directory already has a project.json."
	exit
fi	

if readNo "Create ${project_file} [yN]? " ; then 
	stdErr "User cancelled initializing project."
	exit
fi	

# Start building up the JSON file
project_json="{\n\t\"name\": \"${project_name}\""

stdOut "Initializing project ${project_name}..."

# Get the shortname
read -p "Shortname for project (ProperCase expected): " shortname
project_json+=",\n\t\"shortname\": \"${shortname}\""

# Calculate the slug
project_slug="$(toLowerCase "${shortname}")"
project_json+=",\n\t\"slug\": \"${project_slug}\""

# Get the project type
read -p "Type of project [site]: " project_type
project_type="${project_type:-site}"
project_json+=",\n\t\"type\": \"${project_type}\""

# Get the Box IP
#box_ip_file="$(pwd)/IP"
#box_ip="$(if [ -f "${box_ip_file}" ] ; then cat "${box_ip_file}" ; fi)"
#if [ -n "${box_ip}" ] ; then 
#	project_json+=",\n\t\"box\": {\n\t\t\"ip_address\": \"${box_ip}\"\n\t}"
#fi

# Write the project.json
echo  -e "${project_json}\n}"> $project_file

stdOut "\n$(cat "${project_file}")\n"

#stdOut "Comleted writing ${project_file}."

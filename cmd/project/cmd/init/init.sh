#
# Command: box project init <project_name>
#

#
# Tab Constants
#
t1="\n\t"
t2="\n\t\t"
t3="\n\t\t\t"
t4="\n\t\t\t\t"

echo "${BOXCLI_OPTIONS}"
exit


if noArgsPassed ; then
	stdErr "No project name passed."
	exit
fi

project_name="$1"

# Start building up the JSON file
project_json="{${t1}\"name\": \"${project_name}\""
stdOut "Initializing project ${project_name}..."

# Get the shortname
read -p "Shortname for project (ProperCase expected): " shortname
project_json+=",${t1}\"shortname\": \"${shortname}\""

# Calculate the slug
project_slug="$(toLowerCase "${shortname}")"
project_json+=",${t1}\"slug\": \"${project_slug}\""

# Get the project type
#read -p "Type of project [site]: " project_type
project_type="${project_type:-site}"
project_json+=",${t1}\"type\": \"${project_type}\""

#
# Set the site theme
#
site_theme="${site_theme:-${project_slug}-theme}"
project_json+=",${t1}\"site\": {${t2}\"theme\": \"${site_theme}\"${t1}}"

#
# Set the box version
#
box_ver="${box_ver:-${BOXCLI_BOX_VER}}"
project_json+=",${t1}\"box\": {${t2}\"version\": \"${box_ver}\"${t1}}"


#
# Set the hosts
#
local_role="${local_role:-local}"
staging_role="${staging_role:-stage}"
production_role="${production_role:-production}"

local_domain="${local_domain:-${project_slug}.dev}"
staging_domain="${local_domain:-stage.${project_slug}.com}"
production_domain="${local_domain:-www.${project_slug}.com}"

dev_webroot_path="${webroot_path:-www}"
dev_wordpress_path="${wordpress_path:-www/wp}"
dev_content_path="${content_path:-www/content}"

webroot_path="${webroot_path:-www}"
wordpress_path="${wordpress_path:-www}"
content_path="${content_path:-wp-content}"


project_json+=",${t1}\"hosts\": " 
	project_json+="{${t2}\"roles\": "
		project_json+="{${t3}\"local\": \"${local_role}\""
		project_json+=",${t3}\"on_commit\": \"${staging_role}\""
		project_json+=",${t3}\"production\": \"${production_role}\""
	project_json+="${t2}}"
	project_json+=",${t2}\"list\":"
		project_json+="{${t3}\"${local_role}\": "
			project_json+="{${t4}\"domain\": \"${local_domain}\""
			project_json+=",${t4}\"webroot_path\": \"${dev_webroot_path}\""
			project_json+=",${t4}\"wordpress_path\": \"${dev_wordpress_path}\""
			project_json+=",${t4}\"content_path\": \"${dev_content_path}\""
		project_json+="${t3}}"	
		project_json+=",${t3}\"${staging_role}\": "
			project_json+="{${t4}\"domain\": \"stage.${staging_domain}.com\""
			project_json+=",${t4}\"webroot_path\": \"${webroot_path}\""
			project_json+=",${t4}\"wordpress_path\": \"${wordpress_path}\""
			project_json+=",${t4}\"content_path\": \"${content_path}\""
		project_json+="${t3}}"	
		project_json+=",${t3}\"${production_role}\": "
			project_json+="{${t4}\"domain\": \"stage.${production_domain}.com\""
			project_json+=",${t4}\"webroot_path\": \"${webroot_path}\""
			project_json+=",${t4}\"wordpress_path\": \"${wordpress_path}\""
			project_json+=",${t4}\"content_path\": \"${content_path}\""
		project_json+="${t3}}"	
	project_json+="${t2}}"
project_json+="${t1}}"


#
# Test to ensure we don't overwrite an existing directory
#
project_dir="$(pwd)/${local_domain}"
if [ -d "${project_dir}" ] ; then 
	stdErr "Aborting; project directory exists: ${project_dir}"
	exit
fi	

#
# Ask if the user wants to create the project
#
if readNo "Create project [${project_name}] in ${project_dir}" ; then 
	stdErr "User cancelled initializing project."
	exit
fi	

#
# Create project directory
#
mkdir -p "${project_dir}"
cd "${project_dir}"
stdOut "Project directory created."

#
# Test to ensure we don't overwrite an existing project.json
#
project_file="${project_dir}/project.json"
if [ -f "${project_file}" ] ; then 
	stdErr "Aborting; project JSON exists: ${project_file}"
	exit
fi	

#
# Create standard directories
#
mkdir -p archive
mkdir -p sql
mkdir -p www
mkdir -p www/wp
mkdir -p www/content
stdOut "Standard directories created."

#
# Generate Vagrantfile
#
box util generate-vagrantfile --quiet
stdOut "Vagrantfile generated."

#
# Generate .gitignore
# @TODO generate from a template
#
echo ".idea" > .gitignore
stdOut ".gitignore generated."

#
# Generate README.md
# @TODO generate from a template
#
echo "# ${project_name}" > README.md
stdOut "README.md generated."

#
# Generate project.json
#
echo  -e "${project_json}\n}"> $project_file
stdOut "${project_file} generated."



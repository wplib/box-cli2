#@IgnoreInspection BashAddShebang
#
# Command: box project create <name>
#

#
# Tab Constants
#
if ! noArgsPassed ; then
	name="$1"
else
	name="WPLib Box"
fi

#
# Set hostname first
#
hostname="$(toLowerCase "$(sanitizeDomain "$(getSwitchValue "hostname" "${name:=wplib.box}")")")"

#
# Set top-level project values
#
if strContains "${name}" "." ; then
	project_name="$(stripExtension "${name}")"
else	
	project_name="${name}"
fi

if strContains "${hostname}" "." ; then
	project_slug="$(stripExtension "${hostname}")"
else	
 	project_slug="${hostname}"
	hostname+="${BOXCLI_DEFAULT_LOCAL_TLD}"
fi

if hasSwitchValue "project-slug" ; then
	project_slug="$(getSwitchValue "project-slug")"
fi

if hasSwitchValue "project-name" ; then
	project_name="$(getSwitchValue "project-name")"
fi
project_name="$(toProperCase "${project_name}")"
shortname="$(toProperCase "$(sanitizeIdentifier "$(getSwitchValue "shortname" "${project_slug}")")")"
project_slug="$(toLowerCase "$(getSwitchValue "project-slug" "${shortname}")")"
project_type="${project_type:-site}"
project_version="0.1.0-alpha"

#
# Set site-specific information
#
site_theme="$(toLowerCase "$(getSwitchValue "site-theme" "${project_slug}-theme")")"

#
# Set the box version & IP address
#
box_version="${box_version:-${BOXCLI_BOX_VERSION}}"
ip_address="10.10.10.$(( ( RANDOM % 240 ) + 10 ))"

#
# Set the PHP version
#
php_version="${php_version:-7.0}"

#
# Set the host roles and hosts
#
domain_sans_ext="$(stripExtension "${hostname}")"

local_role="${local_role:-local}"
staging_role="${staging_role:-stage}"
production_role="${production_role:-production}"

local_domain="www.${hostname}"
staging_domain="stage.${domain_sans_ext}.com"
production_domain="www.${domain_sans_ext}.com"

dev_webroot_path="$(sanitizePath "$(getSwitchValue "webroot-path" "${dev_webroot_path:-www}")")"
dev_core_path="$(sanitizePath "$(getSwitchValue "core-path" "${dev_core_path:-${dev_webroot_path}/wp}")")"
dev_content_path="$(sanitizePath "$(getSwitchValue "content-path" "${dev_content_path:-${dev_webroot_path}/content}")")"
dev_wpconfig_path="$(sanitizePath "$(getSwitchValue "config-path" "${dev_wpconfig_path:-${dev_content_path}}")")"
dev_config_path="$(sanitizePath "$(getSwitchValue "secrets-path" "${dev_config_path:-${dev_config_path}/config}")")"

webroot_path="${webroot_path:-}"
core_path="${core_path:-}"
content_path="${content_path:-wp-content}"
boot_path="${boot_path:-}"
config_path="${config_path:-}"

#
#
#
wp_version="$(findLatestWordPressVersion)"

#
# Test to ensure we don't overwrite an existing directory
#
project_dir="$(pwd)/${hostname}"
if [ -d "${project_dir}" ] ; then
	stdErr "Aborting; project directory exists: ${project_dir}"
	exit
fi

#
# Ask if the user wants to create the project
#
if ! isNoPrompt && readNo "Create project in ${project_dir}/" ; then
	stdErr "User cancelled project creation."
	exit
fi

#
# Test to ensure we don't overwrite an existing project.json
#
project_file="${project_dir}/project.json"
if [ -f "${project_file}" ] ; then
	stdErr "Aborting; project JSON exists: ${project_file}"
	exit
fi

#
# Start building up the JSON file
#
json="$(cat <<JSON
{
    "name": "${project_name}",
    "shortname": "${shortname}",
    "slug": "${project_slug}",
    "type": "${project_type}",
    "version": "${project_version}",
    "description": "${project_name}",
    "framework": "wordpress",
    "services": {
        "database": "mysql",
        "webserver": "nginx",
        "processvm": "php${php_version}",
        "kvstore": "redis"
    },
    "wordpress": {
        "version": "${wp_version}",
        "site": {
            "theme": "${site_theme}"
        },
        "themes": {
            "list": {}
        },
        "plugins":  {
            "list": {}
        },
        "hosts": {
            "list": {
                "${local_role}": {
                    "core_path": "${dev_core_path}",
                    "content_path": "${dev_content_path}",
                    "boot_path": "${dev_wpconfig_path}"
                },
                "${staging_role}": {
                    "core_path": "${core_path}",
                    "content_path": "${content_path}",
                    "boot_path": "${boot_path}"
                },
                "${production_role}": {
                    "core_path": "${core_path}",
                    "content_path": "${content_path}",
                    "boot_path": "${boot_path}"
                }
            }
        }
    },
    "php": {
        "version": "${php_version}",
        "libraries": {
            "list": {}
        }
    },
    "box": {
        "hostname": "${hostname}",
        "version": "${box_version}",
        "ip_address": "${ip_address}"
    },
    "hosts": {
        "roles": {
            "local": "${local_role}",
            "on_commit": "${staging_role}",
            "production": "${production_role}"
        },
        "list": {
            "${local_role}": {
                "domain": "${local_domain}",
                "webroot_path": "${dev_webroot_path}"
                "config_path": "${dev_config_path}"
            },
            "${staging_role}": {
                "domain": "${staging_domain}",
                "webroot_path": "${webroot_path}"
                "config_path": "${config_path}"
            },
            "${production_role}": {
                "domain": "${production_domain}",
                "webroot_path": "${webroot_path}"
                "config_path": "${config_path}"
            }
        }
    }
}
JSON
)"

#
# Create directories, files and project.json
#
if ! isDryRun ; then

    #
    # Install WordPress core
    #
    box util install-wordpress-core \
        --project_dir="${project_dir}" \
        --quiet

    #
    # Output HOSTNAME and IP files for Vagrantfile to read
    #
    echo "${hostname}" > HOSTNAME
    echo "${ip_address}" > IP

    #
    # Generate project.json
    #
    echo  -e "${json}"> $project_file

    #
    # Generate Vagrantfile
    #
    box util generate-vagrantfile --quiet

    #
    # Generate .gitignore
    # @TODO generate from a template
    #
    echo ".idea" > .gitignore

    #
    # Generate README.md
    # @TODO generate from a template
    #
    echo "# ${project_name}" > README.md

fi

#
# Finally...
#
if isJSON ; then
    #
    # Output project.json, if caller requested it.
    #
    stdOut "${json}"
else
    if ! isQuiet ; then
        #
        # Generate summary, it caller did request it be suppressed
        #
        plural="host's"
        summary="$(cat <<TEXT
Creating project...

  Project:
    Project Dir:    ${project_dir}
    Project File:   ${project_file}
    Project Name:   ${project_name}
    Project Slug:   ${project_slug}
    Project Type:   ${project_type}
    Shortname:      ${shortname}
    Version:        ${project_version}
  Box:
    Hostname:       ${hostname}
    IP Address:     ${ip_address}
    Version:        ${box_version}
  Site:
    Theme:          ${site_theme}
  Host Roles:
    local:          ${local_role}
    on_commit:      ${staging_role}
    production:     ${production_role}
  Hosts:
    ${local_role}:
      domain:         ${local_domain}
      webroot_path:   ~/${dev_webroot_path}
      core_path:      ~/${dev_core_path}
      content_path:   ~/${dev_content_path}
    ${staging_role}:
      domain:         ${staging_domain}
      webroot_path:   ~/${webroot_path}
      core_path:      ~/${core_path}
      content_path:   ~/${content_path}
    ${production_role}:
      domain:         ${production_domain}
      webroot_path:   ~/${webroot_path}
      core_path:      ~/${core_path}
      content_path:   ~/${content_path}

NOTE: ~/ is only shorthand here for the ${plural} root directory.
DO NOT use "~/" as a path prefix in your project.json file.
For the server in the local role ~/ is also the project directory.
When deployed to a staging or production host, that structure may
differ because your WordPress host may enforce a specific structure.

Project [$(pwd)/] created.
TEXT
        )"
        #
        # Output summary, if caller did not request it be suppressed.
        #
        stdOut "${summary}"
    fi
fi

#
# Skip outputting anything quitting this
#
setQuiet
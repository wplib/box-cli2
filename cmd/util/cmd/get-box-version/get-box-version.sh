#
# Command: box util get-box-version
#

box_version="$(box util get-project-info ".box.version")" 
stdOut "${box_version}"



#
# Command: box util get-webroot-dir
#

echo "$(box util find-project-dir)/$(box util read-project-file ".site.webroot_dir")" 
exit


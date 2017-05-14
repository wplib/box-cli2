#
# Command: box webroot archive 
#

project_dir="$(findProjectDir)"
webroot_dir="$(getWebrootDir)"
webroot_path="$(getWebrootPath)"

cd "${project_dir}"
mkdir -p archive 

if readNo "Archive [${webroot_dir}] directory" ; then 
	exit 1
else

	content_dir="$(getContentDir)"
	content_path="$(getContentPath)"

	suffix="$(date +"%F-%H-%M-%S")"
	uploads='/tmp'
	if readYes "Omit archiving [${content_dir}/uploads] directory" ; then 
		uploads="${content_path}/uploads"
		suffix+="-nouploads"
	fi

	delete_webroot=""
	if readYes "Delete [${webroot_dir}] directory and all its contents" ; then
		delete_webroot="yes"
	fi
	archive_file="${webroot_path/\//-}-archive-${suffix}.zip"
	tmp_filepath="${BOXCLI_TMP_DIR}/${archive_file}"
	#
	# -r: Recursive into sudirectories
	# -m: Move into archive_file (delete original files)
	# -o: Make archive_file as old as latest entry
	# -q: Operate quietly
	# -T: Test archive_file integrity
	# -9: Compress better
	#
	zip -rmoqT9 "${tmp_filepath}" "${webroot_path}" -x "${uploads}/*"
	archive_path="archive/${webroot_path}"
	mkdir -p "${archive_path}"
	archive_filepath="${archive_path}/${archive_file}"
	mv "${tmp_filepath}" "${archive_filepath}"

	if [ "yes" == "${delete_webroot}" ] ; then 
		rm -rf "${webroot_path}"
	fi
fi

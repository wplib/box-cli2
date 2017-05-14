#
# Recognizer for a WPEngine Site Full Backup
# 

filepath="$1"


#
# First check to see if there are files in the zip 
# found inside a /wpengine-common/ directory
#
result="$(unzip -l "${filepath}" | grep "/mu-plugins/wpengine-common/")"
if isEmpty "${result}" ; then
	return 1
fi

#
# Next check to see if the wpconfig.php file contains a reference to
# wpengine.com, which is should for $wpe_all_domains 
#
result="$(unzip -p "${filepath}" "wp-config.php" | grep "wpengine.com")"
if isEmpty "${result}" ; then
	return 1
fi

#
# Finally check to see if there is mysql.sql file in /wp-content/
#
result="$(unzip -l "${filepath}" | grep "wp-content/mysql.sql")"
if isEmpty "${result}" ; then
	return 1
fi

#
# If all the above tests pass then this is a WPEngine Site Fullbackup
# 
cat <<json
{
	"source": "wpengine",
	"scope": "site",
	"type": "fullbackup", 
	"slug": "wpengine-site-fullbackup",
	"filepath": "${filepath}"
}
json
return 0
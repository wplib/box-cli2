#
# Installable Command: box util move-to-project-dir <source_file> 
#

pattern="$1"
git grep "${pattern}" $(git rev-list --all)
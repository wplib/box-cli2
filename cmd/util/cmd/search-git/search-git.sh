#
# Installable Command: box util search-git <pattern>
#

pattern="$1"
git grep "${pattern}" $(git rev-list --all)
#!/usr/bin/env bash
#
# reset.sh

# Set Bash Strict Mode (Unofficial) 
# See http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# So globs with no matches return empty
# See 2.2 in https://www.dwheeler.com/essays/filenames-in-shell.html
shopt -s nullglob

# Extended pattern matching enabled:
#	See http://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html#Pattern-Matching
#
# Required by A-Bash-Template
# See line 45 https://github.com/richbl/a-bash-template/blob/master/bash_template.sh
shopt -s extglob

#!/bin/bash
set -eu

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
. functions.sh

if [ $# -eq 0 ]; then
  cat <<_EOT_
usage : $currentDir/port.sh {Name}
e.g.  : $currentDir/port.sh database-foo
_EOT_
  exit 1
fi

optName=$1

exitIfNotExistVersion "$optName"
optVersion=$(getVersionByName "$optName")

exitIfNotExistPortFile "$optName" "$optVersion"
optPort=$(getPortByName "$optName" "$optVersion")

echo "$optPort"

#!/bin/bash

# Get format option
format=""
while getopts ":f:" opt; do
  case ${opt} in
  f)
    format="$OPTARG"
    ;;
  \?)
    echo "Invalid option: -$OPTARG" 1>&2
    exit 1
    ;;
  :)
    echo "Option -$OPTARG requires an argument." 1>&2
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

currentDir="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"
cd $currentDir
. functions.sh

optName=$1

exitIfNotExistVersion "$optName"
optVersion=$(getVersionByName "$optName")

exitIfNotExistPortFile "$optName" "$optVersion"
optPort=$(getPortByName "$optName" "$optVersion")

dir=$currentDir/versions/$optVersion

./stop.sh -f "$format" $optName $optVersion $optPort

set -eu
exitIfNotExistDir $dir/datadir/$optName
exitIfRunningPort $optPort
[ -d "$dir/datadir/$optName" ] && rm -fr $dir/datadir/$optName

normalOutputs=""
normalOutputs="${normalOutputs}MySQL Successfully deleted. $optName $optVersion $optPort"

jsonOutputs=""
jsonOutputs="$jsonOutputs{\"message\": \"MySQL Successfully deleted.\", \"name\": \"$optName\", \"version\": \"$optVersion\", \"port\": \"$optPort\"}"

# Output
if [ "$format" = "json" ]; then
  echo -e "${jsonOutputs}"
else
  echo -e "${normalOutputs}"
fi

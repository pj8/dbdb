#!/bin/bash

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
. functions.sh

optName=$1

exitIfNotExistVersion "$optName"
optVersion=$(getVersionByName "$optName")

exitIfNotExistPortFile "$optName" "$optVersion"
optPort=$(getPortByName "$optName" "$optVersion")

dir=$currentDir/versions/$optVersion

./stop.sh $optName $optVersion $optPort
sleep 1

set -eu
exitIfNotExistDir $dir/datadir/$optName
exitIfRunningPort $optPort
[ -d "$dir/datadir/$optName" ] && rm -fr $dir/datadir/$optName
echo MongoDB Successfully deleted. $optName $optVersion $optPort

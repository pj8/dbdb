#!/bin/bash
set -eu

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
. functions.sh

optName=$1

exitIfNotExistVersion "$optName"
optVersion=$(getVersionByName "$optName")

exitIfNotExistPortFile "$optName" "$optVersion"
optPort=$(getPortByName "$optName" "$optVersion")

dir=$currentDir/versions/$optVersion

exitIfNotExistDir $dir/datadir/$optName
exitIfNotRunningPort $optPort
[ -f "$dir/datadir/$optName/mongodb.pid" ] && kill $(cat $dir/datadir/$optName/mongodb.pid) && rm -f $dir/datadir/$optName/mongodb.pid
[ -f "$dir/datadir/$optName/mongodb.port" ] && cp $dir/datadir/$optName/mongodb.port $dir/datadir/$optName/mongodb.port.last
[ -f "$dir/datadir/$optName/mongodb.port" ] && rm -f $dir/datadir/$optName/mongodb.port
echo MongoDB Successfully stopped. $optName $optVersion $optPort

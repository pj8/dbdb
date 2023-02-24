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
$dir/basedir/src/redis-cli -p $optPort shutdown
[ -f "$dir/datadir/$optName/redis.port" ] && cp $dir/datadir/$optName/redis.port $dir/datadir/$optName/redis.port.last
[ -f "$dir/datadir/$optName/redis.port" ] && rm -f $dir/datadir/$optName/redis.port
echo Redis Successfully stopped. $optName $optVersion $optPort

#!/bin/bash
set -eu

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
. functions.sh

optName=$1
optVersion=$2
optPort=$3
dir=$currentDir/versions/$optVersion

exitIfNotExistDir $dir/datadir/$optName
exitIfNotRunningPort $optPort
$dir/basedir/src/redis-cli -p $optPort shutdown
cp $dir/datadir/$optName/redis.port $dir/datadir/$optName/redis.port.last
rm -f $dir/datadir/$optName/redis.port
echo Redis Successfully stopped. $optName $optVersion $optPort

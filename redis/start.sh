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
exitIfRunningPort $optPort

# start
$dir/basedir/src/redis-server \
 $dir/datadir/$optName/redis.conf \
 --port $optPort \
 --dir $dir/datadir/$optName \
 --pidfile $dir/datadir/$optName/redis.pid \
 --daemonize yes
echo $optPort > $dir/datadir/$optName/redis.port
echo "Your config file is located $dir/datadir/$optName/redis.conf"
echo Redis Successfully started. $optName $optVersion $optPort

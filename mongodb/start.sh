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
$dir/basedir/bin/mongod \
 --config $dir/datadir/$optName/mongod.conf \
 --dbpath $dir/datadir/$optName \
 --logpath $dir/datadir/$optName/mongodb.log \
 --pidfilepath $dir/datadir/$optName/mongodb.pid \
 --port $optPort \
 --fork
echo MongoDB Successfully started. $optName $optVersion $optPort

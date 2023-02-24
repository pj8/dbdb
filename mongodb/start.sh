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
exitIfRunningPort $optPort

# start
$dir/basedir/bin/mongod \
 --config $dir/datadir/$optName/mongod.conf \
 --dbpath $dir/datadir/$optName \
 --logpath $dir/datadir/$optName/mongodb.log \
 --pidfilepath $dir/datadir/$optName/mongodb.pid \
 --port $optPort \
 --fork
echo $optPort > $dir/datadir/$optName/mongodb.port
echo "Your config file is located $dir/datadir/$optName/mongod.conf"
echo MongoDB Successfully started. $optName $optVersion $optPort

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
kill `cat $dir/datadir/$optName/mongodb.pid` && rm -f $dir/datadir/$optName/mongodb.pid
cp $dir/datadir/$optName/mongodb.port $dir/datadir/$optName/mongodb.port.last
rm -f $dir/datadir/$optName/mongodb.port
echo MongoDB Successfully stopped. $optName $optVersion $optPort

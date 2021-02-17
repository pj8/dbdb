#!/bin/bash

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
. functions.sh

confirm || exit 1

optName=$1
optVersion=$2
optPort=$3
dir=$currentDir/versions/$optVersion

./stop.sh $optName $optVersion $optPort

set -eu
exitIfNotExistDir $dir/datadir/$optName
exitIfRunningPort $optPort
rm -fr $dir/datadir/$optName
echo Redis Successfully deleted. $optName $optVersion $optPort

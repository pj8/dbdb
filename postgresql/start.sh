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
$dir/basedir/bin/pg_ctl \
 --pgdata $dir/datadir/$optName \
 --log $dir/datadir/$optName/postgres.log \
 -o "-p $optPort" \
 start
echo PostgreSQL Successfully started. $optName $optVersion $optPort

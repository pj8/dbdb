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
$dir/basedir/bin/pg_ctl \
 --pgdata $dir/datadir/$optName \
 --log $dir/datadir/$optName/postgres.log \
 -w \
 -o "-p $optPort" \
 start
head -1 $dir/datadir/$optName/postmaster.pid > $dir/datadir/$optName/postgresql.pid
echo $optPort > $dir/datadir/$optName/postgresql.port
echo "Your config file is located $dir/datadir/$optName/postgresql.conf"
echo PostgreSQL Successfully started. $optName $optVersion $optPort

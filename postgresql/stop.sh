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
$dir/basedir/bin/pg_ctl \
 --pgdata $dir/datadir/$optName \
 --log $dir/datadir/$optName/postgres.log \
 -w \
 -o "-p $optPort" \
 stop
[ -f "$dir/datadir/$optName/postgresql.pid" ] && rm -f $dir/datadir/$optName/postgresql.pid
[ -f "$dir/datadir/$optName/postgresql.port" ] && cp $dir/datadir/$optName/postgresql.port $dir/datadir/$optName/postgresql.port.last
[ -f "$dir/datadir/$optName/postgresql.port" ] && rm -f $dir/datadir/$optName/postgresql.port
echo PostgreSQL Successfully stopped. $optName $optVersion $optPort

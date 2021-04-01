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
$dir/basedir/bin/pg_ctl \
 --pgdata $dir/datadir/$optName \
 --log $dir/datadir/$optName/postgres.log \
 -w \
 -o "-p $optPort" \
 stop
rm -f $dir/datadir/$optName/postgresql.pid
cp $dir/datadir/$optName/postgresql.port $dir/datadir/$optName/postgresql.port.last
rm -f $dir/datadir/$optName/postgresql.port
echo PostgreSQL Successfully stopped. $optName $optVersion $optPort

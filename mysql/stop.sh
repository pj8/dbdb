#!/bin/bash
set -eu

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
. functions.sh

optName=$1
optVersion=$2
optPort=$3
optSocket=/tmp/dbdb_mysql_$optPort.sock
dir=$currentDir/versions/$optVersion

exitIfNotExistDir $dir/datadir/$optName
exitIfNotRunningPort $optPort
$dir/basedir/bin/mysqladmin --user=root --host=localhost --port=$optPort --socket=$optSocket shutdown
[ -f "$dir/datadir/$optName/mysql.port" ] && cp $dir/datadir/$optName/mysql.port $dir/datadir/$optName/mysql.port.last
[ -f "$dir/datadir/$optName/mysql.port" ] && rm -f $dir/datadir/$optName/mysql.port
echo MySQL Successfully stopped. $optName $optVersion $optPort

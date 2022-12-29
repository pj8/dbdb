#!/bin/bash
set -eu

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
. functions.sh

optName=$1
optVersion=$2
optPort=$3
optUser=_dbdb_mysql
optSocket=/tmp/dbdb_mysql_$optPort.sock
dir=$currentDir/versions/$optVersion

exitIfNotExistDir $dir/datadir/$optName
exitIfRunningPort $optPort
$dir/basedir/bin/mysqld \
 --defaults-file=$dir/datadir/$optName/my.cnf \
 --daemonize \
 --user=$optUser \
 --port=$optPort \
 --socket=$optSocket \
 --basedir=$dir/basedir \
 --plugin-dir=$dir/basedir/lib/plugin  \
 --datadir=$dir/datadir/$optName \
 --log-error=$dir/datadir/$optName/mysqld.err \
 --pid-file=$dir/datadir/$optName/mysql.pid
echo $optPort > $dir/datadir/$optName/mysql.port
echo "Your config file is located $dir/datadir/$optName/my.cnf"
echo MySQL Successfully started. $optName $optVersion $optPort

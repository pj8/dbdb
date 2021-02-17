#!/bin/bash
set -eu

# usage : ./create.sh {Name} {MysqlVersion} {Port}
# e.g.  : ./create.sh foo 5.7.31 53306
# e.g.  : ./create.sh bar 8.0.23 53306

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
. functions.sh

os=`getOS`
optName=$1
optVersion=$2
optPort=$3
optFileName=mysql-${optVersion}-${os}
optUser=_dbdb_mysql
optSocket=/tmp/dbdb_mysql_$optPort.sock
dir=$currentDir/versions/$optVersion

exitIfExistDir $dir/datadir/$optName
exitIfRunningPort $optPort

getUrlFileAs https://dbdb.3a.company/mysql/$optFileName.tar.gz $optFileName.tar.gz
mkdir -p $dir/datadir/$optName
extractFile $dir $optFileName

$dir/basedir/bin/mysqld \
  --initialize-insecure \
  --user=$optUser \
  --port=$optPort \
  --socket=$optSocket \
  --basedir=$dir/basedir \
  --plugin-dir=$dir/basedir/lib/plugin  \
  --datadir=$dir/datadir/$optName \
  --log-error=$dir/datadir/$optName/mysqld.err \
  --pid-file=$dir/datadir/$optName/mysql.pid

echo "#my.cnf"                   > $dir/datadir/$optName/my.cnf
echo "[mysqld]"                 >> $dir/datadir/$optName/my.cnf
echo "bind-address = 127.0.0.1" >> $dir/datadir/$optName/my.cnf
echo "my.cnf is here. $dir/datadir/$optName/my.cnf"

echo Successfully created.
cd $currentDir
printDebug $optName $optVersion $optPort

#!/bin/bash
set -eu

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir

if [ $# -eq 0 ]; then
  cat <<_EOT_
usage : $currentDir/create.sh {Name} {MysqlVersion} {Port}
e.g.  : $currentDir/create.sh mysql5-foo 5.7.31 13306
e.g.  : $currentDir/create.sh mysql8-bar 8.0.30 23306
_EOT_
  exit 1
fi

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

getUrlFileAs https://dbdb.project8.jp/mysql/$optFileName.tar.gz $optFileName.tar.gz
mkdir -p $dir/datadir/$optName
extractFile $dir $optFileName

$dir/basedir/bin/mysqld \
  --no-defaults \
  --initialize-insecure \
  --user=$optUser \
  --port=$optPort \
  --socket=$optSocket \
  --basedir=$dir/basedir \
  --plugin-dir=$dir/basedir/lib/plugin  \
  --datadir=$dir/datadir/$optName \
  --log-error=$dir/datadir/$optName/mysqld.err \
  --pid-file=$dir/datadir/$optName/mysql.pid

echo $optPort > $dir/datadir/$optName/mysql.port.init

echo "#my.cnf"                   > $dir/datadir/$optName/my.cnf
echo "[mysqld]"                 >> $dir/datadir/$optName/my.cnf
echo "bind-address = 127.0.0.1" >> $dir/datadir/$optName/my.cnf
echo "my.cnf is here. $dir/datadir/$optName/my.cnf"

echo MySQL Successfully created. $optName $optVersion $optPort
cd $currentDir
printDebug $optName $optVersion $optPort

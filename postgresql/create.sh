#!/bin/bash
set -eu

# usage : ./create.sh {Name} {PostgresqlVersion} {Port}
# e.g.  : ./create.sh pg1 12.4-1 55432

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
. functions.sh

os=`getOS`
optName=$1
optVersion=$2
optPort=$3
optFileName=postgresql-${optVersion}-${os}
dir=$currentDir/versions/$optVersion

exitIfExistDir $dir/datadir/$optName
exitIfRunningPort $optPort

getUrlFileAs https://dbdb.3a.company/postgresql/$optFileName.tar.gz $optFileName.tar.gz
mkdir -p $dir/datadir/$optName
extractFile $dir $optFileName

# install for linux
if [ ! -d $dir/basedir/bin ]; then
  if [ $os = "linux" ]; then
    cd $dir/basedir
    ./configure --prefix=`pwd`
    make
    make install
    rm -fr config contrib doc src
  fi
fi

# initdb
$dir/basedir/bin/initdb \
 --pgdata=$dir/datadir/$optName \
 --username=postgres \
 --encoding=UTF-8 \
 --locale=en_US.UTF-8
echo "postgresql.conf is here. $dir/datadir/$optName/postgresql.conf"

echo Successfully created.
cd $currentDir
printDebug $optName $optVersion $optPort

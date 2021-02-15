#!/bin/bash
set -eu

# usage : ./create.sh {Name} {RedisVersion} {Port}
# e.g.  : ./create.sh redis1 6.0.10 56379
# e.g.  : ./create.sh redis1 5.0.10 56379

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
. functions.sh

optName=$1
optVersion=$2
optPort=$3
optFileName=redis-${optVersion}
dir=$currentDir/versions/$optVersion

exitIfExistDir $dir/datadir/$optName
exitIfRunningPort $optPort

mkdir -p $dir/datadir/$optName
getUrlFileAs https://dbdb.3a.company/redis/$optFileName.tar.gz $optFileName.tar.gz
extractFile $dir $optFileName
if [ ! -e $dir/basedir/src/redis-server ]; then
  cd $dir/basedir
  make
fi

# create redis.conf
if [ ! -f $dir/datadir/$optName/redis.conf ]; then
  cd $dir/datadir/$optName
  cp $dir/basedir/redis.conf .
  echo "port $optPort" >> redis.conf
  echo "dir $dir/datadir/$optName" >> redis.conf
  echo "daemonize yes" >> redis.conf
fi
echo "redis.conf is here. $dir/datadir/$optName/redis.conf"

echo Successfully created.
cd $currentDir
printDebug $optName $optVersion $optPort

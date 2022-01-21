#!/bin/bash
set -eu

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir

if [ $# -eq 0 ]; then
  cat <<_EOT_
# usage : $currentDir/create.sh {Name} {RedisVersion} {Port}
# e.g.  : $currentDir/create.sh redis50-hoge 5.0.14 16379 # Error 'make' on M1 Mac.
# e.g.  : $currentDir/create.sh redis60-piyo 6.0.16 26379
# e.g.  : $currentDir/create.sh redis62-fuga 6.2.6  36379
_EOT_
  exit 1
fi

. functions.sh

optName=$1
optVersion=$2
optPort=$3
optFileName=redis-${optVersion}
dir=$currentDir/versions/$optVersion

exitIfExistDir $dir/datadir/$optName
exitIfRunningPort $optPort

getUrlFileAs https://dbdb.3a.company/redis/$optFileName.tar.gz $optFileName.tar.gz
mkdir -p $dir/datadir/$optName
extractFile $dir $optFileName

if [ ! -e $dir/basedir/src/redis-server ]; then
  cd $dir/basedir
  make
fi

# create redis.conf
if [ ! -f $dir/datadir/$optName/redis.conf ]; then
  cd $dir/datadir/$optName
  cp $dir/basedir/redis.conf .
fi
echo "redis.conf is here. $dir/datadir/$optName/redis.conf"

echo $optPort > $dir/datadir/$optName/redis.port.init

echo Redis Successfully created. $optName $optVersion $optPort
cd $currentDir
printDebug $optName $optVersion $optPort

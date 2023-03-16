#!/bin/bash
set -eu

currentDir="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"
cd $currentDir

if [ $# -eq 0 ]; then
  cat <<_EOT_
# usage : $currentDir/create.sh {Name} {RedisVersion} {Port}
# e.g.  : $currentDir/create.sh redis50-foo 5.0.14 16379 # "make" causes an error on M1 Mac.
# e.g.  : $currentDir/create.sh redis60-bar 6.0.16 26379
# e.g.  : $currentDir/create.sh redis62-baz 6.2.6  36379
# e.g.  : $currentDir/create.sh redis62-qux 6.2.6  random
_EOT_
  exit 1
fi

. functions.sh

os=$(getOS)
optName=$1
optVersion=$2
optPort=$(getOptPort $3)
optFileName=redis-${optVersion}-${os}
dir=$currentDir/versions/$optVersion

exitIfDuplicatedName $optName
exitIfExistDir $dir/datadir/$optName
exitIfRunningPort $optPort

getUrlFileAs https://dbdb.project8.jp/redis/$optFileName.tar.gz $optFileName.tar.gz
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

echo $optPort >$dir/datadir/$optName/redis.port.init

echo Redis Successfully created. $optName $optVersion $optPort
cd $currentDir
getCommands $optName $optVersion $optPort

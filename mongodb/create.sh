#!/bin/bash
set -eu

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir

if [ $# -eq 0 ]; then
  cat <<_EOT_
# usage : $currentDir/create.sh {Name} {MongodbVersion} {Port}
# e.g.  : $currentDir/create.sh mongo4-foo 4.4.10 27017
# e.g.  : $currentDir/create.sh mongo5-bar 5.0.3  37017

_EOT_
  exit 1
fi

. functions.sh

os=`getOS`
optName=$1
optVersion=$2
optPort=$3
optFileName=mongodb-${optVersion}-${os}
optUser=_dbdb_mongodb
optSocket=/tmp/dbdb_mongodb_$optPort.sock
dir=$currentDir/versions/$optVersion

exitIfExistDir $dir/datadir/$optName
exitIfRunningPort $optPort

getUrlFileAs https://dbdb.3a.company/mongodb/$optFileName.tar.gz $optFileName.tar.gz
mkdir -p $dir/datadir/$optName
extractFile $dir $optFileName

echo $optPort > $dir/datadir/$optName/mongodb.port.init

echo "#mongod.conf" > $dir/datadir/$optName/mongod.conf
echo "mongod.conf is here. $dir/datadir/$optName/mongod.conf"

echo MongoDB Successfully created. $optName $optVersion $optPort
cd $currentDir
printDebug $optName $optVersion $optPort

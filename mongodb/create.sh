#!/bin/bash
set -eu

# usage : ./create.sh {Name} {MongodbVersion} {Port}
# e.g.  : ./create.sh mongo1 4.4.3 27017

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
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
echo "#mongod.conf" > $dir/datadir/$optName/mongod.conf
echo "mongod.conf is here. $dir/datadir/$optName/mongod.conf"

echo Successfully created.
cd $currentDir
printDebug $optName $optVersion $optPort

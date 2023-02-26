#!/bin/bash
set -eu

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir

if [ $# -eq 0 ]; then
  cat <<_EOT_
usage : $currentDir/create.sh {Name} {PostgresqlVersion} {Port}
e.g.  : $currentDir/create.sh pg124-foo 12.4 54321
e.g.  : $currentDir/create.sh pg126-bar 12.6 54322
e.g.  : $currentDir/create.sh pg132-baz 13.2 54323
e.g.  : $currentDir/create.sh pg132-qux 13.2 random
_EOT_
  exit 1
fi

. functions.sh

os=`getOS`
optName=$1
optVersion=$2
optPort=$(getOptPort $3)
optFileName=postgresql-${optVersion}-${os}
dir=$currentDir/versions/$optVersion

exitIfDuplicatedName $optName
exitIfExistDir $dir/datadir/$optName
exitIfRunningPort $optPort

getUrlFileAs https://dbdb.project8.jp/postgresql/$optFileName.tar.gz $optFileName.tar.gz
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

echo $optPort > $dir/datadir/$optName/postgresql.port.init

echo PostgreSQL Successfully created. $optName $optVersion $optPort
cd $currentDir
printDebug $optName $optVersion $optPort

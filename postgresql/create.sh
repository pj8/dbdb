#!/bin/bash
set -eu

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir

if [ $# -eq 0 ]; then
  cat <<_EOT_
usage : $currentDir/create.sh {Name} {PostgresqlVersion} {Port}
e.g.  : $currentDir/create.sh pg124-foo  12.4 54321
e.g.  : $currentDir/create.sh pg126-bar  12.6 54322
e.g.  : $currentDir/create.sh pg132-hoge 13.2 54323
_EOT_
  exit 1
fi

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

echo PostgreSQL Successfully created. $optName $optVersion $optPort
cd $currentDir
printDebug $optName $optVersion $optPort

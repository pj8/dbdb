#!/bin/bash
set -eu

# Get format option
format=""
while getopts ":f:" opt; do
  case ${opt} in
  f)
    format="$OPTARG"
    ;;
  \?)
    echo "Invalid option: -$OPTARG" 1>&2
    exit 1
    ;;
  :)
    echo "Option -$OPTARG requires an argument." 1>&2
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

currentDir="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"
cd $currentDir

if [ $# -eq 0 ]; then
  cat <<_EOT_ >&2
usage : $currentDir/create.sh {Name} {MemcachedVersion} {Port}
e.g.  : $currentDir/create.sh memcached16-foo 1.6.31 11211
e.g.  : $currentDir/create.sh memcached16-bar 1.6.31 11212
e.g.  : $currentDir/create.sh memcached16-baz 1.6.31 random
_EOT_
  exit 1
fi

. functions.sh

os=$(getOS)
optName=$1
optVersion=$2
optPort=$(getOptPort $3)
optFileName=memcached-${optVersion}-${os}
installDir=$(getInstallDir $(getType))
dir=$installDir/versions/$optVersion

mkdir -p "$dir"
cd $dir

exitIfDuplicatedName $optName
exitIfExistDir $dir/datadir/$optName
exitIfRunningPort $optPort

# libevent
if [ ! -e $dir/share/lib ]; then
  cd $dir
  getUrlFileAs https://dbdb.shueisha-artsdigital.co.jp/memcached/libevent-2.1.12-stable.tar.gz libevent-2.1.12-stable.tar.gz
  echo "Installing libevent..." 1>&2
  tar zxf libevent-2.1.12-stable.tar.gz
  cd $dir/libevent-2.1.12-stable
  ./configure --prefix=$(pwd)/../share > /dev/null 2>&1
  make > /dev/null 2>&1
  make install > /dev/null 2>&1
  cd $dir
fi

# memcached
getUrlFileAs https://dbdb.shueisha-artsdigital.co.jp/memcached/$optFileName.tar.gz $optFileName.tar.gz
mkdir -p $dir/datadir/$optName
extractFile $dir $optFileName
if [ ! -e $dir/basedir/bin/memcached ]; then
  echo "Installing Memcached..." 1>&2
  cd $dir/basedir
  ./configure --prefix=$(pwd) --with-libevent=$(pwd)/../share > /dev/null 2>&1
  make > /dev/null 2>&1
  make install > /dev/null 2>&1
fi

echo $optPort > $dir/datadir/$optName/memcached.port.init

commands=$(getCommands $optName $optVersion $optPort $format)

normalOutputs=""
normalOutputs="${normalOutputs}Memcached Successfully created. $optName $optVersion $optPort\n"
normalOutputs="${normalOutputs}$commands\n"

jsonOutputs=""
jsonOutputs="$jsonOutputs{
  \"message\": \"Memcached Successfully created.\",
  \"name\": \"$optName\",
  \"type\": \"memcached\",
  \"version\": \"$optVersion\",
  \"port\": \"$optPort\",
  \"dataDir\": \"$dir/datadir/$optName\",
  \"confPath\": \"\"
}"

# Output
if [ "$format" = "json" ]; then
  echo -e "${jsonOutputs}"
else
  echo -e "${normalOutputs}"
fi

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
usage : $currentDir/create.sh {Name} {PostgresqlVersion} {Port}
e.g.  : $currentDir/create.sh pg124-foo 12.4 54321
e.g.  : $currentDir/create.sh pg126-bar 12.6 54322
e.g.  : $currentDir/create.sh pg132-baz 13.2 54323
e.g.  : $currentDir/create.sh pg132-qux 13.2 random
_EOT_
  exit 1
fi

. functions.sh

os=$(getOS)
optName=$1
optVersion=$2
optPort=$(getOptPort $3)
optFileName=postgresql-${optVersion}-${os}
installDir=$(getInstallDir $(getType))
dir=$installDir/versions/$optVersion

mkdir -p "$dir"
cd $dir

exitIfDuplicatedName $optName
exitIfExistDir $dir/datadir/$optName
exitIfRunningPort $optPort

getUrlFileAs https://dbdb.shueisha-artsdigital.co.jp/postgresql/$optFileName.tar.gz $optFileName.tar.gz
mkdir -p $dir/datadir/$optName
extractFile $dir $optFileName

# install for linux
if [ ! -d $dir/basedir/bin ]; then
  if [ $os = "linux" ]; then
    echo "Installing..." 1>&2
    cd $dir/basedir
    ./configure --prefix=$(pwd) > /dev/null 2>&1
    make > /dev/null 2>&1
    make install > /dev/null 2>&1
    rm -fr config contrib doc src
  fi
fi

# initdb
$dir/basedir/bin/initdb \
  --pgdata=$dir/datadir/$optName \
  --username=postgres \
  --encoding=UTF-8 \
  --locale=en_US.UTF-8 1>&2
echo $optPort > $dir/datadir/$optName/postgresql.port.init

commands=$(getCommands $optName $optVersion $optPort $format)

normalOutputs=""
normalOutputs="${normalOutputs}postgresql.conf is here. $dir/datadir/$optName/postgresql.conf\n"
normalOutputs="${normalOutputs}PostgreSQL Successfully created. $optName $optVersion $optPort\n"
normalOutputs="${normalOutputs}$commands\n"

jsonOutputs=""
jsonOutputs="$jsonOutputs{
  \"message\": \"PostgreSQL Successfully created.\",
  \"name\": \"$optName\",
  \"type\": \"postgresql\",
  \"version\": \"$optVersion\",
  \"port\": \"$optPort\",
  \"dataDir\": \"$dir/datadir/$optName\",
  \"confPath\": \"$dir/datadir/$optName/postgresql.conf\"
}"

# Output
if [ "$format" = "json" ]; then
  echo -e "${jsonOutputs}"
else
  echo -e "${normalOutputs}"
fi

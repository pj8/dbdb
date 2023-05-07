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
usage : $currentDir/create.sh {Name} {MongodbVersion} {Port}
e.g.  : $currentDir/create.sh mongo4-foo 4.4.10 27017
e.g.  : $currentDir/create.sh mongo5-bar 5.0.3  37017
e.g.  : $currentDir/create.sh mongo5-baz 5.0.3  random
_EOT_
  exit 1
fi

. functions.sh

os=$(getOS)
optName=$1
optVersion=$2
optPort=$(getOptPort $3)
optFileName=mongodb-${optVersion}-${os}
optUser=_dbdb_mongodb
optSocket=/tmp/dbdb_mongodb_$optPort.sock
dir=$currentDir/versions/$optVersion

exitIfDuplicatedName $optName
exitIfExistDir $dir/datadir/$optName
exitIfRunningPort $optPort

getUrlFileAs https://dbdb.project8.jp/mongodb/$optFileName.tar.gz $optFileName.tar.gz
mkdir -p $dir/datadir/$optName
extractFile $dir $optFileName

echo $optPort >$dir/datadir/$optName/mongodb.port.init
echo "#mongod.conf" > $dir/datadir/$optName/mongod.conf


cd $currentDir
commands=$(getCommands $optName $optVersion $optPort $format)

normalOutputs=""
normalOutputs="${normalOutputs}mongod.conf is here. $dir/datadir/$optName/mongod.conf\n"
normalOutputs="${normalOutputs}MongoDB Successfully created. $optName $optVersion $optPort\n"
normalOutputs="${normalOutputs}$commands\n"

jsonOutputs=""
jsonOutputs="$jsonOutputs{
  \"message\": \"MongoDB Successfully created.\",
  \"name\": \"$optName\",
  \"type\": \"mongodb\",
  \"version\": \"$optVersion\",
  \"port\": \"$optPort\",
  \"dataDir\": \"$dir/datadir/$optName\",
  \"confPath\": \"$dir/datadir/$optName/mongod.conf\"
}"

# Output
if [ "$format" = "json" ]; then
  echo -e "${jsonOutputs}"
else
  echo -e "${normalOutputs}"
fi

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
. functions.sh

optName=$1

exitIfNotExistVersion "$optName"
optVersion=$(getVersionByName "$optName")

exitIfNotExistPortFile "$optName" "$optVersion"
optPort=$(getPortByName "$optName" "$optVersion")

dir=$currentDir/versions/$optVersion

exitIfNotExistDir $dir/datadir/$optName
exitIfNotRunningPort $optPort
[ -f "$dir/datadir/$optName/mongodb.pid" ] && kill $(cat $dir/datadir/$optName/mongodb.pid) && rm -f $dir/datadir/$optName/mongodb.pid
[ -f "$dir/datadir/$optName/mongodb.port" ] && cp $dir/datadir/$optName/mongodb.port $dir/datadir/$optName/mongodb.port.last
[ -f "$dir/datadir/$optName/mongodb.port" ] && rm -f $dir/datadir/$optName/mongodb.port

normalOutputs=""
normalOutputs="${normalOutputs}MongoDB Successfully stopped. $optName $optVersion $optPort"

jsonOutputs=""
jsonOutputs="$jsonOutputs{
  \"message\": \"MongoDB Successfully stopped.\",
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

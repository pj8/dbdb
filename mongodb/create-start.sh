#!/bin/bash

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

./create.sh -f "$format" $1 $2 $3 > /dev/null
set -eu
./start.sh -f "$format" $1

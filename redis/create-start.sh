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
usage : $currentDir/create.sh {Name} {RedisVersion} {Port}
e.g.  : $currentDir/create.sh redis60-bar 6.0.16 26379
e.g.  : $currentDir/create.sh redis62-baz 6.2.6  36379
e.g.  : $currentDir/create.sh redis62-qux 6.2.6  random
_EOT_
  exit 1
fi

./create.sh -f "$format" $1 $2 $3 > /dev/null
set -eu
./start.sh -f "$format" $1

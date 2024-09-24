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
usage : $currentDir/create-start.sh {Name} {MemcachedVersion} {Port}
e.g.  : $currentDir/create-start.sh memcached16-foo 1.6.31 11211
e.g.  : $currentDir/create-start.sh memcached16-bar 1.6.31 11212
e.g.  : $currentDir/create-start.sh memcached16-baz 1.6.31 random
_EOT_
  exit 1
fi

./create.sh -f "$format" $1 $2 $3 > /dev/null
set -eu
./start.sh -f "$format" $1

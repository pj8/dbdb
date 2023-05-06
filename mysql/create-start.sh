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
usage : $currentDir/create.sh {Name} {MysqlVersion} {Port}
e.g.  : $currentDir/create.sh mysql5-foo 5.7.31 13306
e.g.  : $currentDir/create.sh mysql8-bar 8.0.30 23306
e.g.  : $currentDir/create.sh mysql8-baz 8.0.30 random
_EOT_
  exit 1
fi

./create.sh -f "$format" $1 $2 $3 > /dev/null
set -eu
./start.sh -f "$format" $1

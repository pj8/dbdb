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
stopOutput=$(./stop.sh -f "$format" $1)

set -eu
startOutput=$(./start.sh -f "$format" $1)

# Output
if [ "$format" = "json" ]; then
  echo "["
  echo "$stopOutput"
  echo ","
  echo "$startOutput"
  echo "]"
else
  echo "$stopOutput"
  echo "$startOutput"
fi

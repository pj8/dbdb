#!/bin/bash

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
./stop.sh $1

sleep 1

set -eu
./start.sh $1

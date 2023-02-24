#!/bin/bash

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir
./create.sh $1 $2 $3

set -eu
./start.sh $1

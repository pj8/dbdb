#!/bin/bash

confirm() {
  read -r -p "${1:-Are you sure? [y/N]} " response
  case "$response" in
    [yY][eE][sS]|[yY])
      true
      ;;
    *)
      false
      ;;
  esac
}

getOS(){
  case "`uname -s`" in
    Linux*)  os=linux;;
    Darwin*) os=macos;;
    *)       echo "It supports Linux and MacOS."; exit 1;;
  esac
  echo $os
}

getCurrentDir(){
  echo "$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
}

exitIfExistDir(){
  if [ -d $1 ]; then
    echo "The dir '$1' is exist."
    exit 1
  fi
}

exitIfNotExistDir(){
  if [ ! -d $1 ]; then
    echo "The dir '$1' is NOT exist."
    exit 1
  fi
}

exitIfRunningPort(){
  if nc -z 127.0.0.1 $1; then
    echo "The port '$1' is already in use."
    exit 1
  fi
}

exitIfNotRunningPort(){
  if nc -z 127.0.0.1 $1; then
    :
  else
    echo "The port '$1' is NOT in use."
    exit 1
  fi
}

getUrlFileAs(){
  if [ ! -e $2 ]; then
    wget $1 -O $2
  fi
}

extractFile(){
  if [ ! -d $1/basedir ]; then
    mkdir -p $1/basedir
    cd $1/basedir
    cp ../../../$2.tar.gz .
    tar zxf $2.tar.gz --strip-components 1
    rm -f $2.tar.gz
  fi
}

printDebug(){
  currentDir=`getCurrentDir`
  echo ""
  echo "# Start"
  echo "$currentDir/start.sh $1 $2 $3"
  echo ""
  echo "# Stop"
  echo "$currentDir/stop.sh $1 $2 $3"
  echo ""
  echo "# Restart"
  echo "$currentDir/restart.sh $1 $2 $3"
  echo ""
  echo "# Status"
  echo "$currentDir/status.sh $1 $2 $3"
  echo ""
  echo "# Connect"
  echo "$currentDir/connect.sh $1 $2 $3"
  echo ""
  echo "# Delete"
  echo "$currentDir/delete.sh $1 $2 $3"
  echo ""
}

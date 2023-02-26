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
  if nc -z 127.0.0.1 $1 > /dev/null 2>&1; then
    echo "The port '$1' is already in use."
    exit 1
  fi
}

exitIfNotRunningPort(){
  if nc -z 127.0.0.1 $1 > /dev/null 2>&1; then
    :
  else
    echo "The port '$1' is NOT in use."
    exit 1
  fi
}

getUrlFileAs(){
  if [ ! -e $2 ]; then
    echo "Downloading... $1"
    if wget $1 -O $2 2>/dev/null || curl $1 -o $2
    then
      :
    else
      rm -f $2
      echo "Not found $2"
      exit 1
    fi
  fi
}

extractFile(){
  if [ ! -d $1/basedir ]; then
    echo "Extracting... $2"
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
  echo "$currentDir/start.sh $1"
  echo ""
  echo "# Stop"
  echo "$currentDir/stop.sh $1"
  echo ""
  echo "# Restart"
  echo "$currentDir/restart.sh $1"
  echo ""
  echo "# Port"
  echo "$currentDir/port.sh $1"
  echo ""
  echo "# Status"
  echo "$currentDir/status.sh $1"
  echo ""
  echo "# Connect"
  echo "$currentDir/connect.sh $1"
  echo ""
  echo "# Delete"
  echo "$currentDir/delete.sh $1"
  echo ""
}

getRandomPort(){
  while true
  do
    randomPort=$(shuf -i "49152-65535" -n 1)
    netstat -a -n | grep ".$randomPort" | grep "LISTEN" 1>/dev/null 2>&1 || break
  done
  echo $randomPort
}

# if $1 name is duplicated in this datastore, exit(1)
exitIfDuplicatedName(){
  name=$1
  currentDir=$(getCurrentDir)
  found=$(find "$currentDir" -type d -name "$name"|wc -l|tr -d '[:space:]')
  if [ "$found" = "0" ]; then
    :
  else
    echo "The name '$name' is already in use."
    find "$currentDir" -type d -name "$name"|grep -E "datadir/$name$"
    exit 1
  fi
}

exitIfNotExistVersion(){
  name=$1
  currentDir=$(getCurrentDir)
  version=$(find "$currentDir" -type d -name "$name"|grep -E "datadir/$name$"|awk -F "/datadir/" '{print $1}'|awk -F "/versions/" '{print $2}')
  if [ "$version" = "" ]; then
    echo "There is no version for the given '$name'."
    exit 1
  fi
}

getVersionByName(){
  name=$1
  currentDir=$(getCurrentDir)
  version=$(find "$currentDir" -type d -name "$name"|grep -E "datadir/$name$"|awk -F "/datadir/" '{print $1}'|awk -F "/versions/" '{print $2}')
  echo "$version"
}

exitIfNotExistPortFile(){
  name=$1
  version=$2
  currentDir=$(getCurrentDir)
  portFiles=$(find "$currentDir/versions/$version" -type f -name "*.port*"|grep -E "/datadir/$name/"||true)
  if [ "$portFiles" = "" ]; then
    echo "There are no port files for the given '$name'."
    exit 1
  fi
}

getService(){
  service=$(basename $(getCurrentDir))
  echo "$service"
}

getPortByName(){
  service=$(getService)
  name=$1
  version=$2
  currentDir=$(getCurrentDir)

  runningPort=$(cat "$currentDir/versions/$version/datadir/$name/$service.port" 2>/dev/null||true)
  lastPort=$(cat "$currentDir/versions/$version/datadir/$name/$service.port.last" 2>/dev/null||true)
  initPort=$(cat "$currentDir/versions/$version/datadir/$name/$service.port.init" 2>/dev/null||true)

  if [ "$runningPort" ]; then
    echo $runningPort
  elif [ "$lastPort" ]; then
    echo $lastPort
  elif [ "$initPort" ]; then
    echo $initPort
  fi
}

getOptPort(){
  optPort=$1
  if [ "$optPort" = "random" ]; then
    getRandomPort
  else
    echo "$optPort"
  fi
}

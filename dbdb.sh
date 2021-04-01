#!/bin/bash
set -eu

currentDir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $currentDir

dbTypes=( mongodb mysql postgresql redis )
for dbType in "${dbTypes[@]}"
do
  for dbVersion in `ls $currentDir/$dbType/versions 2>/dev/null`; do
    if [ -d "$currentDir/$dbType/versions/$dbVersion" ]; then
      for dbServerName in `ls $currentDir/$dbType/versions/$dbVersion/datadir 2>/dev/null`; do
        if [ -d "$currentDir/$dbType/versions/$dbVersion/basedir" ]; then
          if [ -d "$currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName" ]; then
            # pid
            if [ -f "$currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.pid" ]; then
              echo "$dbType.$dbVersion.$dbServerName is running."
            else
              echo "$dbType.$dbVersion.$dbServerName is stopped."
            fi

            # port
            dbPort="{port}"
            if [ -f "$currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port" ]; then
              dbPort=`cat $currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port`
            elif [ -f "$currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port.last" ]; then
              dbPort=`cat $currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port.last`
            fi

            # commands
            echo "$currentDir/$dbType/start.sh   $dbServerName $dbVersion $dbPort"
            echo "$currentDir/$dbType/stop.sh    $dbServerName $dbVersion $dbPort"
            echo "$currentDir/$dbType/restart.sh $dbServerName $dbVersion $dbPort"
            echo "$currentDir/$dbType/status.sh  $dbServerName $dbVersion $dbPort"
            echo "$currentDir/$dbType/connect.sh $dbServerName $dbVersion $dbPort"
            echo "$currentDir/$dbType/delete.sh  $dbServerName $dbVersion $dbPort"
            echo ""
          fi
        fi
      done
    fi
  done
done

#!/bin/bash
set -eu

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

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Get current directory
currentDir="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"
cd "$currentDir"

normalOutputs=""
jsonOutputs=""
dbTypes=(mongodb mysql postgresql redis)
for dbType in "${dbTypes[@]}"; do
  for dbVersion in $(ls "$currentDir/$dbType/versions" 2>/dev/null); do
    if [ -d "$currentDir/$dbType/versions/$dbVersion" ]; then
      for dbServerName in $(ls "$currentDir/$dbType/versions/$dbVersion/datadir" 2>/dev/null); do
        if [ -d "$currentDir/$dbType/versions/$dbVersion/basedir" ]; then
          if [ -d "$currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName" ]; then
            # port
            dbPort="{port}"
            if [ -f "$currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port" ]; then
              dbPort=$(cat "$currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port")
            elif [ -f "$currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port.last" ]; then
              dbPort=$(cat "$currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port.last")
            elif [ -f "$currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port.init" ]; then
              dbPort=$(cat "$currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port.init")
            fi

            # pid
            pidFile="$currentDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.pid"

            # status
            if [ -f "$pidFile" ] && pgrep -F "$pidFile" >/dev/null; then
              status="running"
            else
              status="stopped"
            fi

            # change output color
            if [ "$status" = "running" ]; then
              normalOutputs="$normalOutputs ${GREEN}# $dbServerName (type:$dbType version:$dbVersion port:$dbPort) is ${status}.${NC}\n"
            else
              normalOutputs="$normalOutputs ${RED}# $dbServerName (type:$dbType version:$dbVersion port:$dbPort) is ${status}.${NC}\n"
            fi

            # normalOutputs
            normalOutputs="$normalOutputs $currentDir/$dbType/{start|stop|restart|port|status|connect|delete}.sh $dbServerName\n"
            normalOutputs="$normalOutputs $currentDir/$dbType/start.sh $dbServerName\n"
            normalOutputs="$normalOutputs $currentDir/$dbType/stop.sh  $dbServerName\n"
            normalOutputs="$normalOutputs \n"

            # jsonOutputs
            availableCommands='["start.sh", "stop.sh", "restart.sh", "port.sh", "status.sh", "connect.sh", "delete.sh"]'
            jsonOutputs="$jsonOutputs{\"name\": \"$dbServerName\", \"type\": \"$dbType\", \"version\": \"$dbVersion\", \"port\": \"$dbPort\", \"status\": \"$status\", \"commandPath\": \"$currentDir/$dbType/\", \"availableCommands\": $availableCommands},"
          fi
        fi
      done
    fi
  done
done

# Output
if [ "$format" = "json" ]; then
  echo -e "[${jsonOutputs%?}]"
else
  echo -e "${normalOutputs%?????}"
fi

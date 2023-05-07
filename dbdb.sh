#!/bin/bash
set -eu

getInstallDir() {
  suffix=dbdb
  if [ -z "${XDG_DATA_HOME+x}" ]; then
    echo "$HOME/.local/share/$suffix"
  else
    echo "$XDG_DATA_HOME/$suffix"
  fi
}

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

currentDir="$(
  cd "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"
cd "$currentDir"
installDir=$(getInstallDir)

normalOutputs=""
jsonOutputs=""
dbTypes=(mongodb mysql postgresql redis)
for dbType in "${dbTypes[@]}"; do
  for dbVersion in $(ls "$installDir/$dbType/versions" 2>/dev/null); do
    if [ -d "$installDir/$dbType/versions/$dbVersion" ]; then
      for dbServerName in $(ls "$installDir/$dbType/versions/$dbVersion/datadir" 2>/dev/null); do
        if [ -d "$installDir/$dbType/versions/$dbVersion/basedir" ]; then
          if [ -d "$installDir/$dbType/versions/$dbVersion/datadir/$dbServerName" ]; then
            # port
            dbPort="{port}"
            if [ -f "$installDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port" ]; then
              dbPort=$(cat "$installDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port")
            elif [ -f "$installDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port.last" ]; then
              dbPort=$(cat "$installDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port.last")
            elif [ -f "$installDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port.init" ]; then
              dbPort=$(cat "$installDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.port.init")
            fi

            # pid
            pidFile="$installDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$dbType.pid"

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

            # confName
            if [ "$dbType" = "mongodb" ];then
              confName=mongod.conf
            elif [ "$dbType" = "mysql" ];then
              confName=my.cnf
            elif [ "$dbType" = "postgresql" ];then
              confName=postgresql.conf
            elif [ "$dbType" = "redis" ];then
              confName=redis.conf
            fi

            # jsonOutputs
            availableCommands='["start.sh", "stop.sh", "restart.sh", "port.sh", "status.sh", "connect.sh", "delete.sh"]'
            jsonOutputs="$jsonOutputs{
              \"name\": \"$dbServerName\",
              \"type\": \"$dbType\",
              \"version\": \"$dbVersion\",
              \"port\": \"$dbPort\",
              \"status\": \"$status\",
              \"commandPath\": \"$currentDir/$dbType/\",
              \"availableCommands\": $availableCommands,
              \"dataDir\": \"$installDir/$dbType/versions/$dbVersion/datadir/$dbServerName\",
              \"confPath\": \"$installDir/$dbType/versions/$dbVersion/datadir/$dbServerName/$confName\"
            },"
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

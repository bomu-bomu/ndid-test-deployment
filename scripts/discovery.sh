#! /bin/sh

command=$1
CONFIG="../azure-docker/discovery/docker-compose.yml"
case $command in
  start)
    echo "Start Discovery"
    docker-compose -f $CONFIG up -d
    ;;
  stop)
    echo "Stop Discovery"
    docker-compose -f $CONFIG down
    ;;
  clear)
    curl http://controller:3000/abci-ip/clear
    curl http://controller:3000/api-ip/clear
    echo
    ;;
  *)
    echo "Usage: $0 <start|stop|clear>"
    echo "start - start service"
    echo "stop  - stop service"
    echo "clear - clear ip records in discovery service"
    ;;
esac

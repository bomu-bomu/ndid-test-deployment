#! /bin/sh

command=$1
CONFIG="/ndid-test-deployment/azure-docker/genesis/docker-compose.yml"
case $command in
  start)
    echo "Start Genesis"
    ansible genesis0 -m shell -a "docker-compose -f $CONFIG up -d"
    ;;
  stop)
    echo "Stop Genesis"
    ansible genesis0 -m shell -a "docker-compose -f $CONFIG down"
  	;;
  validators)
    curl -s http://genesis0:45000/validators | grep -c pub_key
    ;;
  *)
    echo "Usage: $0 <start|stop|validators>"
    ;;
esac

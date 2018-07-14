#! /bin/sh

command=$1
CONFIG="/home/tester/ndid-test-deployment/azure-docker/genesis/docker-compose.yml"
genesis=${GENESIS_NAME:-genesis0}

case $command in
  start)
    echo "Start Genesis"
    ansible $genesis -m shell -a "docker-compose -f $CONFIG up -d"
    ;;
  stop)
    echo "Stop Genesis"
    ansible $genesis -m shell -a "docker-compose -f $CONFIG down"
  	;;
  backup)
    echo "Backup Genesis Data"
    conf_path=`dirname $CONFIG`
    ansible $genesis -m archive -a "format=bz2 path=$conf_path/store dest=genesis.tbz" --become
    ansible $genesis -m fetch -a "src=genesis.tbz dest=backup/genesis.tbz flat=yes"
    ;;
  restore)
    echo "Restore Genesis Data"
    conf_path=`dirname $CONFIG`
    ansible $genesis -m file -a "state=absent path=$conf_path/store" --become
    ansible $genesis -m unarchive -a "src=backup/genesis.tbz dest=$conf_path" --become
    ;;
  validators)
    curl -s http://$genesis:45000/validators | grep -c pub_key
    ;;
  *)
    echo "Usage: $0 <start|stop|validators>"
    ;;
esac

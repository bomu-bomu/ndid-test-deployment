#! /bin/bash
command=$1
CONFIG="/home/tester/ndid-test-deployment/azure-docker/secondary/docker-compose.yml"
tm_node="tm-node"

case $command in
#  start)
#    echo "Start Genesis"
#    ansible $tm_node -m shell -a "docker-compose -f $CONFIG up -d"
#    ;;
#  stop)
#    echo "Stop Genesis"
#    ansible $tm_node -m shell -a "docker-compose -f $CONFIG down"
#  	;;
  backup)
    echo "Backup Genesis Data"
    conf_path=`dirname $CONFIG`
    ansible $tm_node -m archive -a "format=bz2 path=$conf_path/store,$conf_path/DID dest=tm_node.tbz" --become
    ansible $tm_node -m fetch -a "src=tm_node.tbz dest=backup/tm_node.tbz"
    ;;
  restore)
    echo "Restore Genesis Data"
    conf_path=`dirname $CONFIG`
    ansible $tm_node -m file -a "state=absent path=$conf_path/store,$conf_path/DID" --become
    ansible $tm_node -m unarchive -a "src=backup/tm_node.tbz dest=$conf_path" --become
    ;;
  reset)
    echo "Reset Genesis Data"
    conf_path=`dirname $CONFIG`
    ansible $tm_node -m file -a "state=absent path=$conf_path/DID" --become
    ansible $tm_node -m file -a "state=absent path=$conf_path/store" --become
    ansible $tm_node -m file -a "state=directory path=$conf_path/store" --become
    ansible $tm_node -m file -a "state=directory path=$conf_path/store/config" --become
    ;;
  config)
    echo "Send tendermint config"
    conf_path=`dirname $CONFIG`
    ansible $tm_node -m copy -a "dest=/home/tester/ndid-test-deployment/azure-docker/secondary/store/config/config.toml src=`pwd`/config.toml" --become --fork 10
    ;;
  refresh)
    echo "Refresh docker image"
    ansible $tm_node -m shell -a "docker-compose -f $CONFIG pull"
    ansible $tm_node -m shell -a "docker system prune -f"
    ;;
  add_validator)
    echo "Add validator"
    start=1
    i=$start
    while [ $i -lt $2 ]
    do
      echo "Add validator from $tm_node-$i"     
      validator=`curl -s http://$tm_node-$i:45000/status | jq -r .result.validator_info.pub_key.value | sed 's/\//%2F/g;s/+/%2B/g'`
      curl -s http://tm-node-0:45000/broadcast_tx_commit?tx=\"val:$validator\"
      i=`expr $i + 1`
      sleep 1
    done
    ;;
  *)
    echo "Usage: $0 <backup|restore|config|refresh|add_validator>"
    ;;
esac

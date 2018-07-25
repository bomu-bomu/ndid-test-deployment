#! /bin/bash

command=$1
AZ_RESOURCE_GROUP="AKSTesting"
NODE_PREFIX="tm-node"
NODE_COUNT=10

start_vm() {
  echo -n "Start VM: "
  i=0
  while [ $i -lt $NODE_COUNT ]
  do
    az vm start -g $AZ_RESOURCE_GROUP -n $NODE_PREFIX-$i --no-wait
    i=`expr $i + 1`
    echo -n "."
  done
  echo " OK"
}

stop_vm() {
  echo -n "Stop VM: "
  i=0
  while [ $i -lt $NODE_COUNT ]
  do
    az vm deallocate -g $AZ_RESOURCE_GROUP -n $NODE_PREFIX-$i --no-wait
    i=`expr $i + 1`
    echo -n "."
  done
  echo " OK"
}

case $command in
  start)
    start_vm
    ;;
  stop)
    stop_vm
    ;;
  update)
    echo "Update vm nodes to latest"
    ansible $NODE_PREFIX -m apt -a "update_cache=yes upgrade=yes" --become --fork=10
    ;;
  repo)
    echo "Update source from git repository"
    ansible tm-node -m git -a "repo=https://github.com/bomu-bomu/ndid-test-deployment.git dest=/home/tester/ndid-test-deployment force=yes" --fork=10
    ;;
  *)
    echo "Usage: $0 <start|stop|update|repo>"
    ;;
esac

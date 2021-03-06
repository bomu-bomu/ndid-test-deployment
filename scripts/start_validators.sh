#!/bin/bash

count=${1:-1}
node=${2:-1}
prefix="tm-node-"

genesis=${GENESIS_NAME:genesis0}

START_SECONDARY_NODE_CMD="docker-compose -f /home/tester/ndid-test-deployment/azure-docker/secondary/docker-compose.yml up -d"
get_total_validators() {
  curl -s http://$genesis:45000/validators | grep -c pub_key
}

get_node_name() {
  current=$1
  name_count=${2:-1}
  prefix="tm-node-"
  if [ $name_count -eq 1 ]
  then
    echo $prefix$current
    return 0
  fi

  word=""
  i=$current
  total=`expr $name_count + $current`
  while [ $i -lt $total ]
  do
    word="$word\n$prefix$i"
    i=`expr $i + 1`
  done
  echo -e $word | sed '/^\s*$/d' | paste -s -d':' -
}

start_time=`date +%s`
i=$node

finish=`expr $count + $node`
count_validators=`get_total_validators`
incr=5
if [ $incr -gt $count ]
then
  incr=$count
fi

while [ $i -lt $finish ]
do
  node_name=`get_node_name $i $incr`
  echo "Start node: $node_name"
  ansible $node_name -m shell -a "GENESIS=$genesis $START_SECONDARY_NODE_CMD"
  i=`expr $i + $incr`
  sleep 1
done

stop_time=`date +%s`
duration=`expr $stop_time - $start_time`
echo
echo "Totol time: $duration seconds"

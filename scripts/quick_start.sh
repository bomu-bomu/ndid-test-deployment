#! /bin/bash
validators=${1:-100}

##  Check that all service is closed
./stop_validators.sh
./genesis.sh stop
./discovery.sh clear

## Start Genesis
./genesis.sh start
sleep 5
## Start populate validators
./start_validators.sh $validators

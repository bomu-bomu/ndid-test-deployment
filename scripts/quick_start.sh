#! /bin/bash

##  Check that all service is closed
./stop_validators.sh
./genesis.sh stop
./discovery.sh clear

## Start Genesis
./genesis.sh start
sleep 5
## Start populate validator
./start_validators.sh 100 0

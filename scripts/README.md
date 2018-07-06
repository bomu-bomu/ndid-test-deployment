# Quick Start Script

## Pre-Assumption
1. Discovery Service's dns name is controller.
2. Tendermint Genesis's dns name is genesis0.
3. Secondary node's dns names are tm-node-[number].

## Prerequisite
- ansible
- docker
- docker-compose
- curl

## Quick and Dirty Start
run
```
./quick_start.sh <node>
```
This command will clear old environment and restart genesis and secondary nodes as specified in `<node>`
#### For example,

```
./quick_start.sh 20 
```
Populate with 20 secondary nodes.

## Discovery Node
```
./discovery.sh <start|stop|clear>
```
- start - start discovery service
- stop - stop discovery service
- clear - clear ip listed in Discovery Service

## Genesis Node
```
./genesis.sh <start|stop|validators>
```
- start - start Genesis Node
- stop - stop Genesis Node
- validators - get total validators known by Genesis

## Secondary Node
```
./start_validators <count> <offset>
```
Start secondary node with validators `<count>` nodes start from `<offset>`
#### Example:
```
./start_validators 20 40
```
This command will start 20 secondary nodes from tm-node-40 to tm-node-59

```
./stop_validators [pattern]
```
Stop validators. If not specified pattern, it will stop all secondary node
#### Example:
```
./stop_validators
./stop_validators tm-node-?
./stop_validators tm-node-2:tm-node-3
```

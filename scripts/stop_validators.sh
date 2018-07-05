#!/bin/bash

node=${1:-all}
ansible $node -m shell -a "docker-compose -f /home/tester/ndid-test-deployment/azure-docker/secondary/docker-compose.yml down"

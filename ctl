#!/bin/bash

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IMAGE=spotify/kafka:latest
NAME=shadow_kafka

function ensure_ip() {
    if [ "$IP" == "" ]; then
       echo "Error: please specify an ip address"
       exit 1
    fi
}

##############################################################################################

COMMAND=$1
IP=$2

# ./ctl run
if [ "$COMMAND" == "run" ]; then
    ensure_ip
    docker rm $NAME
    docker run -p 2181:2181 -p 9092:9092 --name $NAME --env ADVERTISED_HOST=$IP --env ADVERTISED_PORT=9092 spotify/kafka

# ./ctl attach
elif [ "$COMMAND" == "attach" ]; then
    docker exec -it $NAME bash

# ./ctl tail
elif [ "$COMMAND" == "tail" ]; then
    docker logs -f $NAME

# ./ctl producer
elif [ "$COMMAND" == "producer" ]; then
    ensure_ip
    KAFKA_SERVER=$IP make producer

# ./ctl consumer
elif [ "$COMMAND" == "consumer" ]; then
    ensure_ip
    KAFKA_SERVER=$IP make consumer

else
    echo "usage: $0 [command]"
    echo ""
    echo "  run        Run the docker image"
    echo "  attach     Attach to running container (bash prompt)"
    echo "  tail       Tail container logs"
    echo "  consumer   Launch test consumer"
    echo "  producer   Launch test producer"
    echo ""
fi

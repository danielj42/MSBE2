#!/bin/bash

docker run --name media-mongo --publish 27017:27017 --rm -d mongo
docker run -it --link media-mongo:mongo --rm mongo sh -c 'exec mongo "$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/media"'

#!/bin/bash

# 引数によって実行モードを決定
if [ "$1" = "bash" ]; then
  docker run -it --rm \
    --name flutter_runner \
    --network=host \
    --add-host=host.docker.internal:host-gateway \
    -v "$(pwd)/work:/home/alice/work" \
    -v "$(pwd)/dot_gradle:/home/alice/.gradle" \
    -v "$(pwd)/dot_pub-cache:/home/alice/.pub-cache" \
    flutter-runner:1 bash -i
else
  docker run -d \
    --name flutter_runner \
    --network=host \
    --add-host=host.docker.internal:host-gateway \
    -v "$(pwd)/work:/home/alice/work" \
    -v "$(pwd)/dot_gradle:/home/alice/.gradle" \
    -v "$(pwd)/dot_pub-cache:/home/alice/.pub-cache" \
    flutter-runner:1
fi


#ENV GRADLE_HOME="/home/${username}/.gradle"
#ENV PUB_CACHE_HOME="/home/${username}/.pub-cache"


#!/bin/bash

# 引数によって実行モードを決定
if [ "$1" = "bash" ]; then
  docker run -it --rm \
    --name flutter_runner \
    --network=host \
    --add-host=host.docker.internal:host-gateway \
    -v "$(pwd)/work:/home/alice/work" \
    flutter-runner:1 bash -i
else
  docker run -d \
    --name flutter_runner \
    --network=host \
    --add-host=host.docker.internal:host-gateway \
    -v "$(pwd)/work:/home/alice/work" \
    flutter-runner:1
fi


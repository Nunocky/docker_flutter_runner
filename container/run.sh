#!/bin/bash

# usage : 
#    ./run.sh bash ... start interactive mode
#    ./run.sh      ... start as jenkins build node

username=alice

if [ $# -lt 1 ];then
    OPTION_IT="-it"
else
    OPTION_IT=""
fi

docker run -it --rm $OPTION_IT \
  --name flutter_runner_$username \
  --network=host \
  --add-host=host.docker.internal:host-gateway \
  -v "$(pwd)/work:/home/${username}/work" \
  -v flutter_runner_gradle:/home/${username}/.gradle \
  -v flutter_runner_pub_cache:/home/${username}/.pub-cache \
  flutter-runner:1 \
  ${@:1} 


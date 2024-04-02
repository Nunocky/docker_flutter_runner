#!/bin/bash

name=alice

docker run --rm \
  --name flutter_runner_$name \
  --network=host \
  --add-host=host.docker.internal:host-gateway \
  -v "$(pwd)/work:/home/runner/work" \
  -v flutter_runner_gradle:/home/runner/.gradle \
  -v flutter_runner_pub_cache:/home/runner/.pub-cache \
  flutter-runner:1


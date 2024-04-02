#!/bin/sh

docker build -t flutter-runner:1 .

docker volume create flutter_runner_gradle
docker volume create flutter_runner_pub_cache

#!/bin/sh

#docker run -d \
#	--restart=always \
#	--name flutter_runner \
#	--network=host \
#	-v work:/home/alice/work \
#	flutter-runner

docker run -it --rm \
	--name flutter_runner \
	-v ./work:/home/alice/work \
	flutter-runner:1 bash -i

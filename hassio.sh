#!/bin/bash

PWD="$( cd "$(dirname "$0")" ; pwd -P )"
BASENAME=`basename -s .sh $0`
NAME=$BASENAME
HASSIO_HOME_DIR=`dirname $0`
HASSIO_HOME_DIR=`realpath $HASIO_HOME_DIR`

CFG_DIR=${HASSIO_HOME_DIR}/config

cmd() {
     	sudo docker container exec -t -i $NAME $*
}

start() {
	sudo docker run --init -d \
		--name=$NAME \
		--rm \
		-e "TZ=America/New_York" \
		-v $CFG_DIR:/config \
		--net=host \
		homeassistant/home-assistant:stable
}

stop() {
	sudo docker container stop $NAME
}

restart() {
	sudo docker container restart $NAME
}

usage() {
	echo "Usage : ${BASENAME}.sh [-s | start] | [-S | stop] | [[-e | exec] ...] | [shell ...]"
}

case $1 in
	'-S' | 'stop')
		stop
		;;

	'-s' | 'start')
		start
		;;
	'-e' | 'exec')
		shift 
		cmd $@
		;;
	'shell')
		cmd /bin/bash
		;;
	*)
		usage
esac

#!/bin/bash

#
# Establish variables
#
. ./.envvars.sh

# this also stops "variable is not set" warnings
export HOSTUSER=$(whoami)
export HOSTUID=$(id -u)
export HOSTGID=$(id -g)
export CONTROLLERIMAGENAME=ansible-controller-homelab-${HOSTUSER}
export CONTROLLERCONTAINERNAME="homelab-controller"

function build_image() {

    docker-compose $docker_compose_args \
        build --no-cache \
        --build-arg HOSTUSER=$HOSTUSER \
        --build-arg HOSTUID=$HOSTUID \
        --build-arg HOSTGID=$HOSTGID \
        --build-arg SSHDIR=$SSHDIR \
        --build-arg ANSIBLEDIR=$ANSIBLEDIR \
        --build-arg KUBECONFIGDIR=$KUBECONFIGDIR

    status=$?
    if [ $status != 0 ]; then
        echo $0: docker-compose exit status nonzero, NOT tagging the image
        exit $status
    fi

    timestamp=$(date +%Y%m%dT%H%M%S)
    echo $0: adding tag $CONTROLLERIMAGENAME:$timestamp
    docker tag $CONTROLLERIMAGENAME:latest $CONTROLLERIMAGENAME:$timestamp

}

function bash_exec() {
    docker-compose exec ansiblecontroller bash
}

# replaces task specific function calls to up/down/start/stop
function compose_container() {
    docker-compose $docker_compose_args $1
}

function container_run() {
    # TODO double check ANSIBLEPLAYBOOKS is set
    ANSIBLEPLAYBOOKS=$1

    docker run -it -d \
    --name ansiblecontroller \
    -v $HOME/.ssh:/root/.ssh \
    -v $ANSIBLEPLAYBOOKS:/ansible \
    ansiblecontroller
}

while getopts "bBusdrt" opt; do
  case $opt in
    b)
      build_image
    ;;
    B)
      bash_exec
    ;;
    s)
      compose_container start
    ;;
    t)
      compose_container stop
    ;;
    u)
      compose_container "up -d"
    ;;
    d)
      compose_container down
    ;;
    r)
      container_run
    ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
    ;;
  esac
done
shift $((OPTIND-1))

#!/bin/bash

#
# Establish variables
#
. ./.envvars.sh

# this also stops "variable is not set" warnings
export hostuser=$(whoami)
export hostuid=$(id -u)
export hostgid=$(id -g)
export imagename=ansible-controller-homelab-${hostuser}
export containerhostname="homelab-controller"

function build_image() {

    docker-compose $docker_compose_args \
        build --no-cache \
        --build-arg hostuser=$hostuser \
        --build-arg hostuid=$hostuid \
        --build-arg hostgid=$hostgid \
        --build-arg SSHDIR=$SSHDIR \
        --build-arg ANSIBLEDIR=$ANSIBLEDIR \
        --build-arg KUBECONFIGDIR=$KUBECONFIGDIR

    status=$?
    if [ $status != 0 ]; then
        echo $0: docker-compose exit status nonzero, NOT tagging the image
        exit $status
    fi

    timestamp=$(date +%Y%m%dT%H%M%S)
    echo $0: adding tag $imagename:$timestamp
    docker tag $imagename:latest $imagename:$timestamp

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
    --name ansible-controller \
    -v $HOME/.ssh:/root/.ssh \
    -v $ANSIBLEPLAYBOOKS:/ansible \
    ansible-controller
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

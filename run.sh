#!/bin/bash

# TODO double check that
ANSIBLEPLAYBOOKS=$1

docker run -it -d \
--name ansible-controller \
-v $HOME/.ssh:/root/.ssh \
-v $ANSIBLEPLAYBOOKS:/ansible \
ansible-controller

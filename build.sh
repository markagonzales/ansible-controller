#!/bin/bash

ansible-builder build --no-cache --prune-images --container-runtime=docker \
    --build-arg EE_BASE_IMAGE=quay.io/rockylinux/rockylinux:9 \
    --tag hooplad/ansible:rocky9-2.14

ansible-builder build --no-cache --prune-images --container-runtime=docker \
    --build-arg EE_BASE_IMAGE=quay.io/rockylinux/rockylinux:8 \
    --tag hooplad/ansible:rocky8-2.14

docker push hooplad/ansible:rocky9-2.14

docker push hooplad/ansible:rocky8-2.14

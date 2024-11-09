#!/bin/bash

ansible-builder build --no-cache --prune-images \
    --build-arg EE_BASE_IMAGE=quay.io/rockylinux/rockylinux:9 \
    --tag hooplad/ansible:rocky9-2.14

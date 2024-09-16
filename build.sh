
ansible-builder build --prune-images --build-arg EE_BASE_IMAGE=registry.access.redhat.com/ubi8/ubi:latest --tag ansible:8-2.14

ansible-builder build --prune-images --build-arg EE_BASE_IMAGE=registry.access.redhat.com/ubi9/ubi:latest --tag ansible:9-2.14

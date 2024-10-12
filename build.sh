
# this worked. i can't drop rhel8 base image due to repo restrictions
ansible-builder build --no-cache --prune-images --build-arg EE_BASE_IMAGE=quay.io/rockylinux/rockylinux:8 --tag hooplad/ansible:rocky8-2.14

docker push hooplad/ansible:rocky8-2.14

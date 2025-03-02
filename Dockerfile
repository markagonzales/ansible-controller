FROM quay.io/rockylinux/rockylinux:8

ARG HOSTUSER
ARG HOSTUID
ARG HOSTGID
ARG BUILD_REPO=/ansible-build

RUN apt-get -y update && \
    apt-get -y upgrade && \
    ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get -y install ansible-core sudo python3-pip

RUN echo "%${HOSTUSER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${HOSTUSER}

RUN echo "ansible-playbook -vv -i inventory -e HOSTUSER=${HOSTUSER} -e HOSTUID=${HOSTUID} -e HOSTGID=${HOSTGID} controller.yaml $@" \
    > /usr/local/bin/run-ansible && \
    chmod +x /usr/local/bin/run-ansible

COPY . ${BUILD_REPO}
RUN cd ${BUILD_REPO}/playbooks && \
    /usr/local/bin/run-ansible && \
    rm -rf ${BUILD_REPO}

USER ${HOSTUID}:${HOSTGID}
WORKDIR /workspace

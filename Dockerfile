FROM ubuntu:latest

ARG hostuser
ARG hostuid
ARG hostgid
ARG build_repo=/ansible-build

# ubuntu asks for timezone information
# when installing ansible...

RUN apt-get -y update && \
    apt-get -y upgrade && \
    ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt install -y ansible-core

COPY . ${build_repo}
RUN \
    cd ${build_repo}/playbooks && \
    ansible-playbook -vvvv \
      -i inventory \
      -e hostuser=${hostuser} \
      -e hostuid=${hostuid} \
      -e hostgid=${hostgid} \
      -e build_repo=${build_repo} \
      controller.yaml && \
   rm -rf ${build_repo}

USER ${hostuid}:${hostgid}
WORKDIR /ansible

FROM ubuntu

RUN apt-get update;\
    apt-get upgrade;\
    apt install -y ansible=2.9.*

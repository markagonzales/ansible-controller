# ansible-controller

This repo uses Ansible in a few ( 2? ) ways. First, this demonistrats a pattern to a "initial build environment". This can then be used to build further images with `ansible-builder` controllers in unrelated projects.

## Requirements

* docker
* docker compose

The execution environments can use most distros as a base. So far this setup has had success with Rocky 8, Fedora 40, and some success with UBI8.

## Useage

```
docker compose build
docker compose up -d
docker compose stop
```

# Ansible Builder Workflow

```
ansible-builder build --prune-images
```
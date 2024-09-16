# ansible-controller

Use this section to just build a standalone Ansible controller. See the next major section on work to generically build an Ansible image.

## Requirements

docker
docker compose

## Useage

docker compose build
docker compose up -d
docker compose stop


# Ansible Builder Workflow

```
ansible-builder build --prune-images
```
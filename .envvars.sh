# Common script snippet to set variables

# Exporting these variables stops "variable is not set" warnings
export hostuser=$(id -un)

# Small stab towards Windows compatibility
if [ "$HOME" = "" ]; then
    export HOME=/home/$hostuser
fi

# These names are compatible with env.example
export hostuid=$(id -u)
export hostgid=$(id -g)
export SSHDIR=$HOME/.ssh
export ANSIBLEDIR=$HOME/.ansible
export KUBECONFIGDIR=$HOME/.kube
export AWSCONFIGDIR=$HOME/.aws

docker_compose_args=""

# Selectively overrides ".env" to allow for personal customization
# of the container environment
for path in .env.$hostuser $HOME/.ansible/ansible-controller.env ; do
    if [ -f $path -a -r $path ]; then
	docker_compose_args="$docker_compose_args --env-file=$path"
	break
    fi
done

set_compose_file=""
override=$HOME/.ansible/ansible-controller.override.yml
if [ -f $override ]; then
    docker_compose_args="$docker_compose_args -f docker-compose.yml -f $override"
fi

if [ "$docker_compose_args" != "" ]; then
    echo Adding \"$docker_compose_args\"
fi

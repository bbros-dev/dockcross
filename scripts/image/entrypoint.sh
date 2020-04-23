#!/usr/bin/env bash

source /etc/profile.d/00-ocix-env.sh

# This is the entrypoint script for the dockerfile. Executed in the
# container at runtime.

if [[ $# == 0 ]]; then
  # Presumably the image has been run directly, so help the user get
  # started by outputting the ocix script
  m4 --include=/etc/profile.d /ocix/ocix.m4
  exit 0
fi

# If we are running a container natively, we want to create a user in the container
# with the same UID and GID as the user on the host machine, so that any files
# created are owned by that user. Without this they are all owned by root.
# The ocix script sets the BUILDER_UID and BUILDER_GID vars.
if [[ -n $BUILDER_UID ]] && [[ -n $BUILDER_GID ]]; then

    groupadd -o -g $BUILDER_GID $BUILDER_GROUP 2> /dev/null
    useradd -o -m -g $BUILDER_GID -u $BUILDER_UID $BUILDER_USER 2> /dev/null
    export HOME=/home/${BUILDER_USER}
    shopt -s dotglob
    cp -r /root/* $HOME/
    chown -R $BUILDER_UID:$BUILDER_GID $HOME

    # Additional updates specific to the image
    if [[ -e /ocix/pre_exec.sh ]]; then
        /ocix/pre_exec.sh
    fi

    # Execute project specific pre execution hook
    if [[ -e /work/.ocix ]]; then
       gosu $BUILDER_UID:$BUILDER_GID /work/.ocix
    fi

    # Enable passwordless sudo capabilities for the user
    chown root:$BUILDER_GID $(which gosu)
    chmod +s $(which gosu); sync

    # Run the command as the specified user/group.
    exec gosu $BUILDER_UID:$BUILDER_GID "$@"
else
    # Just run the command as root.
    exec "$@"
fi

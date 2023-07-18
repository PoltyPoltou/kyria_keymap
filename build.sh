#!/bin/bash
if [[ ! -e container_id ]]; then
    echo container_id file is missing. Please create it and write inside your zmk container id.
    exit 1
fi
CONTAINER_NAME=$(cat container_id)
IS_ALREADY_RUNNING=""
if [[ -n $(docker ps | grep $CONTAINER_NAME) ]]; then
    IS_ALREADY_RUNNING="true"
else
    docker start $CONTAINER_NAME
fi
docker exec -t $CONTAINER_NAME sh -c "/workspaces/zmk/kyria_keymap/container_build.sh $1"
docker exec -t $CONTAINER_NAME sh -c "cp /workspaces/zmk/app/build/left/zephyr/zmk.uf2 /workspaces/zmk/kyria_keymap/left.uf2"
docker exec -t $CONTAINER_NAME sh -c "cp /workspaces/zmk/app/build/right/zephyr/zmk.uf2 /workspaces/zmk/kyria_keymap/right.uf2"
docker exec -t $CONTAINER_NAME sh -c "chown -R 1000:1000 /workspaces/zmk/kyria_keymap/*.uf2"
if [[ -z IS_ALREADY_RUNNING ]]; then
    docker stop $CONTAINER_NAME
fi
printf -v date '%(%Y-%m-%d)T' -1
mkdir -p backup_builds/$date
cp config/kyria_rev3.* "backup_builds/$date/"
cp *.uf2 backup_builds/$date

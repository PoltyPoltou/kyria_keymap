#!/bin/bash
CONTAINER_NAME="ee8ee638b3c4"
IS_ALREADY_RUNNING=""
if [[ -n $(docker ps | grep $CONTAINER_NAME) ]]; then
    IS_ALREADY_RUNNING="true"
else
    docker start $CONTAINER_NAME
fi
docker exec -it $CONTAINER_NAME sh -c "/workspaces/zmk/build.sh $1"
docker exec -it $CONTAINER_NAME sh -c "cp /workspaces/zmk/app/build/left/zephyr/zmk.uf2 /workspaces/zmk/zmk-conf/left.uf2"
docker exec -it $CONTAINER_NAME sh -c "cp /workspaces/zmk/app/build/right/zephyr/zmk.uf2 /workspaces/zmk/zmk-conf/right.uf2"
docker exec -it $CONTAINER_NAME sh -c "chown -R 1000:1000 /workspaces/zmk/zmk-conf/*.uf2"
if [[ -z IS_ALREADY_RUNNING ]]; then
    docker stop $CONTAINER_NAME
fi
printf -v date '%(%Y-%m-%d)T' -1
mkdir -p backup_builds/$date
cp config/kyria_rev3.* "backup_builds/$date/"
cp *.uf2 backup_builds/$date
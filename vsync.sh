#!/bin/sh
#此脚本用于远程copy文件或者文件夹之用

REMOTE_USER=wuhan
REMOTE_IP=183.62.205.132
REMOTE_DIR_BASE=/home/${REMOTE_USER}/jiawq/

echo "rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR_BASE}/$1 $2"
rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR_BASE}/$1 $2

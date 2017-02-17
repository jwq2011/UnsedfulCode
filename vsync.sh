
read -p "Enter Remote Server UserName:" REMOTE_USER
read -p "Enter Remote Server IPAddress:" REMOTE_IP
read -p "Enter Remote Server DirBase:" REMOTE_DIR_BASE
read -p "Enter Remote Local DirBase:" LOCAL_DIR_BASE

echo "rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:$REMOTE_DIR_BASE $LOCAL_DIR_BASE"
rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:$REMOTE_DIR_BASE $LOCAL_DIR_BASE

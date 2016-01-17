#!/bin/bash
IMAGE_PATH=Image
REMOTE_USER=os
REMOTE_IP=192.168.1.91
REMOTE_DIR_BASE_APP="/home/app-group"
REMOTE_DIR_BASE_OS="/home/os-group"
TARGET_PRODUCT_ID=${LOCAL_SRC_APP_DIR[$product_number]}

localname="huabao_pnd" 
appservername="35.华宝/K1101A002HBSYC" 
osservername="华宝/PND_K1101A002HBSYC"

packfiles="recover-script \
		boot.img \
		misc.img \
		parameter \
		recovery.img \
		RK3066Loader_uboot.bin \
		appcfg.img \
		system.img \
		logo.bmp \
		kernel.img \
		update-script \
	"
PACKFILES=($packfiles)
LOCAL_SRC_APP_DIR=($localname)
SERVER_SRC_APP_DIR=($appservername) 
SERVER_SRC_OS_DIR=($osservername) 

function pause()
{
echo "Press any key to quit:"
read -n1 -s key
exit 1
}

function check_exit() {
    local ret=$?

    if [ $ret -ne 0 ]; then
        pr_err "file no found, ret＝$ret"
        pause
        exit $ret
    fi
}

function get_project(){
    echo -e "\n"
    for ((i=0;i<${#LOCAL_SRC_APP_DIR[@]};i++))
    do
         printf "\t\t%02s :  build %s \n" $i ${LOCAL_SRC_APP_DIR[$i]}
    done
    echo -n "请选择一个数字:"
    while true
    do
        read product_number
        if [[ -z "$product_number" ]]; then
            echo -n "请选择一个数字:"
        else
            break
        fi
    done
}
#
# RSYNC <REMOTE_FILE> <DEST_DIR or DEST_FILE>
#
RSYNCAPP() {
    echo "rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR_BASE_APP}/$1 $2"
    rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR_BASE_APP}/$1 $2
#    check_exit
}

RSYNCOS() {
    echo "rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR_BASE_OS}/$1 $2"
    rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR_BASE_OS}/$1 $2

#    check_exit
}

function sync_os(){
echo -ne "\n\n\n=====================================================================================\n"  
echo -ne "                   sync os image and package config files start ..."
echo -ne "\n=====================================================================================\n\n\n"  

local ret=`rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR_BASE_OS}/${SERVER_SRC_OS_DIR[$product_number]}/system_package/BasePackage.tar.gz ./ | grep "Number of files transferred:" | cut -b 30 | head -1`

if [ $ret -ne 0 ]; then
echo "system package is old, updating package ... ..."
rm -rf ./BasePackage
tar -xvf ./BasePackage.tar.gz -C ./
echo "system package update done ... "
fi
cp -rfa BasePackage/system $IMAGE_PATH/
version="${LOCAL_SRC_APP_DIR[$product_number]}-`date +%Y%m%d%H%S`"
sed -i "s/ro.build.id=.*/ro.build.id=${LOCAL_SRC_APP_DIR[$product_number]}/" `grep "ro.build.id=" -rl $IMAGE_PATH/system/build.prop`
sed -i "s/ro.build.display.id=.*/ro.build.display.id=$version/" `grep "ro.build.display.id" -rl $IMAGE_PATH/system/build.prop`
sed -i "s/ro.product.model=.*/ro.product.model=${LOCAL_SRC_APP_DIR[$product_number]}/" `grep "ro.product.model=" -rl $IMAGE_PATH/system/build.prop`
sed -i "s/ro.product.device=.*/ro.product.device=${LOCAL_SRC_APP_DIR[$product_number]}/" `grep "ro.product.device=" -rl $IMAGE_PATH/system/build.prop`



RSYNCOS package-file/afptool ./
RSYNCOS package-file/rkImageMaker ./
RSYNCOS package-file/make_ext4fs ./
RSYNCOS package-file/package-file ./
RSYNCOS package-file/recover-script  ${IMAGE_PATH}/
RSYNCOS package-file/update-script ${IMAGE_PATH}/
RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/img_release/kernel.img  ${IMAGE_PATH}/
RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/img_release/recovery.img  ${IMAGE_PATH}/
RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/img_release/boot.img  ${IMAGE_PATH}/
RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/img_release/RK3066Loader_uboot.bin ${IMAGE_PATH}/
RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/img_release/logo.bmp ${IMAGE_PATH}/
RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/img_release/parameter ${IMAGE_PATH}/
RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/img_release/misc.img ${IMAGE_PATH}/
RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/oslib/*.* ${IMAGE_PATH}/system/lib/
RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/osbin/* ${IMAGE_PATH}/system/bin/
RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/osapk/*.* ${IMAGE_PATH}/system/app/
RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/bootanimation/*.* ${IMAGE_PATH}/system/media/
RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/unuseful_osapk_list  ${IMAGE_PATH}/
chmod 777 afptool rkImageMaker make_ext4fs
}

function sync_app(){
echo -ne "\n\n\n=====================================================================================\n"  
echo -ne "                              sync app apks start ..."
echo -ne "\n=====================================================================================\n\n\n"  

if [ ! -d "./AppConfig" ]; then
    mkdir -p AppConfig
fi
    RSYNCAPP 8925通用apk/*.apk ${IMAGE_PATH}/system/app/
    RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/system/app/*.apk  ${IMAGE_PATH}/system/app/
    RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/system/lib/*.so  ${IMAGE_PATH}/system/lib/
    RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/system/bin/*  ${IMAGE_PATH}/system/bin/
    RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/system/priv-app/*.apk  ${IMAGE_PATH}/system/priv-app/
    RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/system/ring.mp3  ${IMAGE_PATH}/system/
    RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/system/config_nuoweida.ini  ${IMAGE_PATH}/system/
    RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/config/app/*  ./AppConfig/
    RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/unuseful_appapk_list ${IMAGE_PATH}/
}

function remove_unuseful(){
echo -ne "\n\n\n=====================================================================================\n"  
echo -ne "                         remove unuseful os and app apks ..."
echo -ne "\n=====================================================================================\n\n\n"  
if [ -f "$1" ]; then
    cat $1 | while read LINE
    do
#在UE编辑的时候，行后面会多出一个“.”, 16进制为"OD",导致rm没删除掉,因此在每个apk名字后面加一个空格
        local ret=`echo "$LINE" | sed -e 's/[;]$*/ /g'` 
        if [ -n "$ret" ]; then
            echo "remove $ret"
            rm -rf $2/$ret
        fi
    done
fi

}

function make_systemimg(){
if [ ! -d "./${IMAGE_PATH}" ]; then
    mkdir -p ./${IMAGE_PATH}
fi
sync_os
sync_app
remove_unuseful $IMAGE_PATH/unuseful_osapk_list ${IMAGE_PATH}/system
remove_unuseful $IMAGE_PATH/unuseful_appapk_list ${IMAGE_PATH}/system
echo -ne "\n\n=====================================================================================\n"  
echo -ne "                        start to make system.img..."
echo -ne "\n=====================================================================================\n\n"  

#system_size=`ls -l OriginSystem/system.img | awk '{print $5;}'`
system_size=320729088
[ $system_size -gt "0" ] || { echo "Please make first!!!" && exit 1; }
MAKE_EXT4FS_ARGS=" -L system -S BasePackage/root/file_contexts -a system $IMAGE_PATH/system.img $IMAGE_PATH/system"
ok=0
while [ "$ok" = "0" ]; do
	./make_ext4fs -l $system_size $MAKE_EXT4FS_ARGS &&
	tune2fs -c -1 -i 0 $IMAGE_PATH/system.img &&
	ok=1 || system_size=$(($system_size + 41943040))
done
./e2fsck -fyD $IMAGE_PATH/system.img >/dev/null 2>&1 || true
echo "done"
}

function make_appcfgimg(){
echo -ne "\n\n\n=====================================================================================\n\n\n"  
echo -ne "                             start to make appcfg.img..."
echo -ne "\n=====================================================================================\n\n\n"  
mkdir ./AppConfig/.app
chmod 777 ./AppConfig/.app
MAKE_EXT4FS_CONFIG=" -a system $IMAGE_PATH/appcfg.img AppConfig"
ok=0
while [ "$ok" = "0" ]; do
	./make_ext4fs -l 62914560 $MAKE_EXT4FS_CONFIG >/dev/null 2>&1 &&
	tune2fs -c -1 -i 0 $IMAGE_PATH/appcfg.img >/dev/null 2>&1 && 
	ok=1 || system_size=$(62914560)
done
echo "done"
chmod a+r -R $IMAGE_PATH
}

function make_backupimg(){
mkdir -p backupimage
RSYNCOS package-file/backup/package-file ./backupimage/
./afptool -pack ./backupimage backupimage/backup.img || pause
}

function check_file(){

for ((i=0;i<${#PACKFILES[@]};i++))
do 
if [ ! -f "./${IMAGE_PATH}/${PACKFILES[$i]}" ]; then
	echo "Error:No found ${PACKFILES[$i]} !!!!!"
	pause
fi
done

if [ ! -f "./package-file" ]; then
	echo "Error:No found package-file!"
	pause
fi
}

function main(){
echo -ne "\n\n\n\n=====================================================================================\n"  
echo -ne "                             start to make update.img..."
echo -ne "\n=====================================================================================\n"  
get_project
make_systemimg
make_appcfgimg
make_backupimg
check_file
./afptool -pack ./ Image/update.img || pause
./rkImageMaker -RK30 Image/RK3066Loader_uboot.bin Image/update.img update.img -os_type:androidos || pause
rm -rf Image/system
rm -rf rkImageMaker package-file make_ext4fs Image BasePackage.tar.gz BasePackage backupimage AppConfig afptool
echo -ne "\n\n\n=====================================================================================\n"  
echo -ne "                              Version: $version\n"
echo -ne "                              Making update.img OK."
echo -ne "\n=====================================================================================\n\n\n"  
exit 0
}

main

#!/bin/bash
TOP=`pwd`
ARG1=$1
ARG2=$2

REMOTE_USER=os
REMOTE_IP=192.168.1.91
REMOTE_DIR_BASE="/home/app-group"
REMOTE_DIR_BASE_OS="/home/os-group"
MAKETOOL="${TOP}/RKTools/linux/Linux_Upgrade_Tool_v1.16/rockdev"

#/两个数组里面，服务器对应的目录和项目要对应/

localname="huabao_pnd" 
appservername="35.华宝/K1101A002HBSYC" 

LOCAL_SRC_APP_DIR=($localname)

SERVER_SRC_APP_DIR=($appservername) 
SERVER_SRC_OS_DIR=($osservername) 

build_type="eng"
#rootdir=`pwd`

function pr_red() {
    echo -e "\033[0;31;1m${*}\033[0m"
}

function pr_green() {
    echo -e "\033[0;32;1m${*}\033[0m"
}

function pr_yellow() {
    echo -e "\033[0;33;1m${*}\033[0m"
}

function pr_blue() {
    echo -e "\033[0;34;1m${*}\033[0m"
}

function pr_err() {
    pr_red "${*}"
}

function pr_cutting_line() {
    echo "================================================================"
}

function clear_input() {
    while read -n 1 -t 0.001; do
        true
    done
}

function pause() {
    echo
    echo -n "按任意键继续。。。"
    clear_input
    read -n 1
    echo -e "\b "
}

function error_exit() {
    pause
    exit 1
}

function check_exit() {
    local ret=$?

    if [ $ret -ne 0 ]; then
        pr_err "运行出错。。。ret＝$ret"
        pause
        exit $ret
    fi
}

function get_project(){
    for ((i=0;i<${#LOCAL_SRC_APP_DIR[@]};i++))
    do
        echo -e "\t$i :  build ${LOCAL_SRC_APP_DIR[$i]}"
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

    TARGET_PRODUCT_ID=${LOCAL_SRC_APP_DIR[$product_number]}
    DEST_DIR_BASE="out/target/product/${TARGET_PRODUCT_ID}/system"
}

function is_sync_apk(){
    echo  -n "需要从服务器上下载最新的apk吗? (y/n):"
    while true
    do
        read is_sync
        if [[ "$is_sync" = "y" ]] || [[ "$is_sync" = "Y" ]] || [[ "$is_sync" = "n" ]] || [[ "$is_sync" = "N" ]]; then
            break
        else
            echo  -n "需要从服务器上下载最新的apk吗? (y/n):"
        fi
    done
}

function sync_app(){
    if [[ "$is_sync" = "y" ]] || [[ "$is_sync" = "Y" ]]; then
	echo -e "rsyncing remote app project file, remote dir ${SERVER_SRC_APP_DIR[$product_number]}"
	RSYNCAPP 8925通用apk/*.apk  app/
	RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/system/app/*.apk  app/
	RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/system/lib/*.so  lib/
	RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/system/priv-app/*.apk  priv-app/
	RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/system/ring.mp3  lib/
	RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/system/config_nuoweida.ini  lib/
	RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/config/app/*.*  config/app/
	RSYNCAPP ${SERVER_SRC_APP_DIR[$product_number]}/unuseful_appapk_list ./
    fi
}

function sync_os(){
    RSYNCOS ${SERVER_SRC_OS_DIR[$product_number]}/unuseful_osapk_list  ./
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
#
# RSYNC <REMOTE_FILE> <DEST_DIR or DEST_FILE>
#
RSYNCAPP() {
    echo "rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR_BASE}/$1 ${DEST_DIR_BASE}/$2"
    rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR_BASE}/$1 ${DEST_DIR_BASE}/$2
}

RSYNCOS() {
    echo "rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR_BASE_OS}/$1 $2"
    rsync -vzrtpl --progress --stats -e ssh ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR_BASE_OS}/$1 $2
}

function config_env(){
	. build/envsetup.sh
	lunch ${LOCAL_SRC_APP_DIR[$product_number]}-$build_type
}

function clean_and_build_system(){
    echo -e "\n\n\n  making system.img recovery.img boot.img misc.img ... ... \n\n\n"
    if [ "$ARG1" = "all" ];then
    	make installclean
    fi
    make update-api
    make -j8
}

function build_kernel(){
    echo -e "\n\n\n  making kernel.img ... ... \n\n\n"
    cd ./kernel
    if [ "$ARG1" = "all" ];then
    	make clean
    	rm -rf .config
    fi
    make ${TARGET_PRODUCT_ID}_defconfig
    make kernel.img -j12
    cd ../
}

function create_appcfg(){
    IMAGE_PATH=out/target/product/${TARGET_PRODUCT_ID}
    AppConfig=device/rockchip/${TARGET_PRODUCT_ID}/config/app
    MAKE_EXT4FS_CONFIG="-a system $IMAGE_PATH/appcfg.img $AppConfig"

    echo -e "create appcfg.img...\n"
    ok=0
    while [ "$ok" = "0" ]; do
    	./make_ext4fs -l 62914560 $MAKE_EXT4FS_CONFIG >/dev/null 2>&1 &&
    	tune2fs -c -1 -i 0 $IMAGE_PATH/appcfg.img >/dev/null 2>&1 &&
    	ok=1 || system_size=$(62914560)
    done
}

function create_images(){
    echo "make images"
    sync_app
    remove_unuseful ./out/target/product/${TARGET_PRODUCT_ID}/unuseful_appapk_list out/target/product/${TARGET_PRODUCT_ID}/system
    remove_unuseful ./out/target/product/${TARGET_PRODUCT_ID}/unuseful_osapk_list out/target/product/${TARGET_PRODUCT_ID}/system
    create_appcfg
    cp out/target/product/$TARGET_PRODUCT_ID/appcfg.img  rockdev/Image-$TARGET_PRODUCT_ID/
}

#
#准备生成update.img的各个img等文件
function perpare_pack_env(){
    cd $TOP
    ./mkimage.sh
    mkdir -p rockdev/Image-$TARGET_PRODUCT_ID/Image
    mkdir -p rockdev/Image-$TARGET_PRODUCT_ID/backupimage
    cp -rf ${TOP}/device/rockchip/$TARGET_PRODUCT_ID/parameter/parameter ./rockdev/Image-$TARGET_PRODUCT_ID/
    cp -rf ${TOP}/device/rockchip/$TARGET_PRODUCT_ID/package-file ./rockdev/Image-$TARGET_PRODUCT_ID/
    cp -rf ${TOP}/device/rockchip/$TARGET_PRODUCT_ID/logo.bmp ./rockdev/Image-$TARGET_PRODUCT_ID/
    cp -rf ${TOP}/device/rockchip/$TARGET_PRODUCT_ID/package-file_backup ./rockdev/Image-$TARGET_PRODUCT_ID/backupimage/package-file
    cp ${TOP}/kernel/kernel.img ${TOP}/rockdev/Image-$TARGET_PRODUCT_ID/
    cp ${TOP}/RKTools/linux/Linux_Upgrade_Tool_v1.16/rockdev/afptool ${TOP}/rockdev/Image-$TARGET_PRODUCT_ID/
    cp ${TOP}/RKTools/linux/Linux_Upgrade_Tool_v1.16/rockdev/rkImageMaker ${TOP}/rockdev/Image-$TARGET_PRODUCT_ID/
    cp ${TOP}/RKTools/linux/Linux_Upgrade_Tool_v1.16/rockdev/update-script ${TOP}/rockdev/Image-$TARGET_PRODUCT_ID/
    cp ${TOP}/RKTools/linux/Linux_Upgrade_Tool_v1.16/rockdev/recover-script ${TOP}/rockdev/Image-$TARGET_PRODUCT_ID/

    RSYNCOS package-file/RK3066Loader_uboot.bin ./rockdev/Image-$TARGET_PRODUCT_ID/
    chmod 777 ${TOP}/rockdev/Image-$TARGET_PRODUCT_ID/* 
    cd $TOP
}

function create_updateimg(){
    cd $TOP
    cd ./rockdev/Image-$TARGET_PRODUCT_ID/ 
    ./afptool -pack ./backupimage backupimage/backup.img || pause
    ./afptool -pack ./ Image/update.img || pause
    ./rkImageMaker -RK30 RK3066Loader_uboot.bin Image/update.img update.img -os_type:androidos || pause
    cd $TOP
}

function make_basepackage(){
    cd $TOP
    cd ./out/target/product/${TARGET_PRODUCT_ID}/
    rm -rf BasePackage*
    mkdir BasePackage
    cp -rf system BasePackage/
    cp -rf root BasePackage/
    tar -cjvf BasePackage.tar.gz BasePackage
    cd $TOP
}

function make_updateimg(){
    if [ -d "./rockdev/Image-$TARGET_PRODUCT_ID" ]; then
    	rm -rf rockdev/Image-$TARGET_PRODUCT_ID/*
    fi
    cp -rf ./out/target/product/${TARGET_PRODUCT_ID}/system ./out/target/product/${TARGET_PRODUCT_ID}/systembak
    perpare_pack_env
    create_images
    create_updateimg
    rm -rf ./out/target/product/${TARGET_PRODUCT_ID}/system
    mv ./out/target/product/${TARGET_PRODUCT_ID}/systembak ./out/target/product/${TARGET_PRODUCT_ID}/system
} 

function full(){
    old_time=`date +%s`
    get_project
    is_sync_apk

    config_env
    build_kernel
    clean_and_build_system
    make_basepackage
    if [[ "$is_sync" = "y" ]] || [[ "$is_sync" = "Y" ]]; then
	make_updateimg
    fi
    new_time=`date +%s`
    sw_version=`cat out/target/product/${TARGET_PRODUCT_ID}/system/build.prop | grep ro.build.display.id | sed 's/ro.build.display.id=//'`
    echo
    pr_green "编译完成"
    echo
    echo "编译开始时间：`date -d @${old_time}`"
    echo "编译结束时间：`date -d @${new_time}`"
    echo "编译时长    ：$(((new_time-old_time+30)/60))分钟"
    echo
}

full

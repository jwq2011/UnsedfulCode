#!/bin/bash
IMAGE_PATH=Image
REMOTE_USER=os
REMOTE_IP=192.168.1.91
REMOTE_DIR_BASE_APP="/home/app-group"
REMOTE_DIR_BASE_OS="/home/os-group"
TARGET_PRODUCT_ID=${LOCAL_SRC_APP_DIR[$product_number]}

localname="huabao_pnd \
     huabao \
     kewei  \
     suoling \
     penghui \
     penghui_bmw520 \
	   qiwen_bmw5i \
	   qiwen_bmw3i \
	   beijian	\
	   yl_es250 \
	   yl_nx300 \
	   yl_bmw520 \
	   yl_m3\
	   ylzj \
	   ylzj_furuisi \
	   ylzj_focus \
	   ylzj_963A \
	   youyang \
	   hangsheng \
	   suoling_es250 \
	   suoling_AudiQ3 \
	   suoling_AudiQ5 \
	   suoling_AudiA3 \
	   suoling_benzc \
	   suoling_BenzG \
	   yinzhiyuan \
	   shenghualelv \
	   zhuoyi_bmw5li-D_8858G \
	   zhuoyi_bmw3li-D_8836G \
	   hualingan_benz \
	   beihang_benz \
	   beihang_AudiQ3 \
	   jili_hj_xm \
	   qiwen_benz \
	   hexin_bmw520 \
	   hexin_bmw320li \
	   hexin_bmw520li \
	   hexin_BMWX1 \
	  " 

appservername="35.华宝/K1101A002HBSYC \
	    35.华宝/K1101A002HBSYC_shuangding
	    42.科维-K1102A008KWTY/K1102A008KWTY \
	    37.索菱/K1102A002SLTG  \
	    36.朋辉/K1101A004PHTY  \
	    56.合鑫/K1102Y037_HX_BM5 \
	    45.启文_K1102_QWBMW_APP/K1102A017QWBM5_1024x480  \
	    45.启文_K1102_QWBMW_APP/K1102Y041QWBM3_1280x480  \
	    44.飞音   \
	    46.莹隆/LEXUS  \
	    46.莹隆/NX300 \
	    46.莹隆/BMW  \
	    46.莹隆/Mazda3 \
	    48.滢隆-K1102A019YLTY/K1102A019YLTY   \
	    59.滢隆-K1102A019YLTY_InLand/K1102A019YLTY   \
	    48.滢隆-K1102Z045_YL_FT   \
	    48.滢隆-K1102Z050_YL_963A   \
	    43优扬 \
	    38.航盛K1101A001HSTY \
	    37.索菱/K1102A023_SL_ES250 \
	    37.索菱/K1102Y046_SL_ADQ3/ \
	    37.索菱/K1102Y046_SL_ADQ3/ \
	    37.索菱/K1102Y046_SL_ADA3/ \
	    37.索菱/K1102Y049_SL_BC_C \
	    37.索菱/K1102Y049_SL_BC_C \
	    50.音之源 \
	    52.盛华乐旅 \
	    51.卓翼K1102Y030_ZY_BM5 \
	    51.卓翼宝马3系K1102Y043_ZY_BM3 \
	    55.华凌安/K1102Y034_HLA_BC_奔驰 \
	    37.索菱/K1102Y049_SL_BC_C \
	    37.索菱/K1102Y046_SL_ADQ3 \
	    54熊猫 \
	    57.启文_K1102Y033QWBENZ_1024x600_APP  \
	    56.合鑫/K1102Y037_HX_BM5 \
	    56.合鑫/K1102Y037_HEXIN_BM3 \
	    56.合鑫/K1102Y037_HEXIN_BM5 \
	    56.合鑫/K1102Y037_HEXIN_BMX1 \
      " 
osservername="华宝/PND_K1101A002HBSYC \
    华宝/K1101A002HBSYC   \
		科维/K1102A008KWTY \
		索菱/K1102A002SLTG \
		鹏辉/K1101A004PHTY \
		鹏辉/K1102 \
		启文/K1102A017QWBM5 \
		启文/K1102A017QWBM3 \
		飞音/K1102A018FYTY  \
		莹隆/K1102A018-YL-ES250 \
		莹隆/K1102A029YLNX300 \
		莹隆/K1102A013YLBM5  \
		莹隆/K1102A018-YL-M3 \
		莹隆/K1102A019YLTY   \
		莹隆/K1102A019YLTY_ESCORT   \
		莹隆/K1102Z045-YL-FT   \
		莹隆/K1102Z050-YL-963A   \
		悠扬/K1102A011YYTY  \
		航盛/K1102A014HSTY  \
		索菱/K1102A019-SL-ES250 \
		索菱/K1102Y046_SL_ADQ3 \
		索菱/K1102Y046_SL_ADQ5 \
		索菱/K1102Y046_SL_ADA3 \
		索菱/K1102Y049_SL_BC_C \
		索菱/K1102Y049_SL_BC_G \
		音之源/K1102A027YZYDZ \
		音之源/K1102A027YZYDZ \
		卓翼/BMW520 \
		卓翼/BMW320 \
		华凌安/K1102Y034_HLA_BC \
		北航/K1102Y047_BH_BC \
		北航/K1102Y047_BH_Q3 \
		吉利/K1102Z036_HJ_XM   \
		启文/K1102A027YZYDZ   \
		合鑫/BMW520_ZC \
		合鑫/BMW320 \
		合鑫/BMW520 \
		合鑫/BMWX1 \
		"

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

#!/bin/sh

#For i.MX6 Board Build !

ROOT_DIR=$PWD
KERNEL_DIR=${ROOT_DIR}/kernel_imx
UBOOT_DIR=${ROOT_DIR}/bootable/bootloader/uboot-imx
RAMDISK=${ROOT_DIR}/out/target/product/sabresd_6dq/ramdisk.img

CROSS_TOOLCHAIN=${ROOT_DIR}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
ARCH_CROSS_ENV="ARCH=arm CROSS_COMPILE=${CROSS_TOOLCHAIN}"
LOAD_KERNEL_ENTRY=0x10008000
KERNEL_CFLAGS="KCFLAGS=-mno-android"
KERNEL_ENV="${ARCH_CROSS_ENV} LOADADDR=${LOAD_KERNEL_ENTRY} ${KERNEL_CFLAGS}"

old_time=`date +%s`

if [ -z "$1" ]; then
	TARGET="build_all"
else
	TARGET=$1
fi
OPERATION=$2

export CPUS=`grep -c processor /proc/cpuinfo`
#CPUS=8

function copy_img()
{
	if [ ! -d "./img_release" ]; then
    	mkdir -p img_release
	fi
	cp out/target/product/sabresd_6dq/boot-imx6dl.img img_release/
	cp out/target/product/sabresd_6dq/system.img img_release/
	cp out/target/product/sabresd_6dq/u-boot-imx6dl.imx img_release/
	cp out/target/product/sabresd_6dq/recovery-imx6dl.img img_release/
}

function set_env()
{
#	source build/envsetup.sh
#	lunch sabresd_6dq-eng
	echo -e "\033[32m 1.sabresd_6dq-eng\033[0m"
	echo -e "\033[32m 2.sabresd_6dq-user\033[0m"
	echo -e "\033[32m 3.sabresd_6dq-userdebug\033[0m"
	echo -e "\033[31m Please Select One Build Env!\033[0m"
	echo -ne "\033[36m Direct Press Enter Default To Select\033[0m [sabresd_6dq-eng]:"
	read ENV_SELECT
	if [ -z ${ENV_SELECT} ] || [ ${ENV_SELECT} == "1" ]; then
		source ./env_eng.sh
	elif [ ${ENV_SELECT} == "2" ]; then
		source ./env_user.sh
	elif [ ${ENV_SELECT} == "3" ]; then
		source ./env.sh
	fi
}

function build_all()
{
	source ./cpoverlay.sh
	echo -e "\033[32m Cleaning Kernel!\033[0m"
	make -C ${KERNEL_DIR} distclean
	echo -e "\033[32m Cleaning Uboot!\033[0m"
	make -C ${UBOOT_DIR} distclean
	make update-api
	make -j${CPUS} 2>&1 | tee build.log
}

function build_kernel()
{
	make bootimage -j${CPUS}
}

function build_uboot()
{
	make bootloader -j${CPUS}
}

function build_recovery()
{
	make recoveryimage -j${CPUS}
}

function build_system()
{
	make systemimage -j${CPUS}
}

function print_buildtime()
{
	new_time=`date +%s`
	echo
	echo "编译开始时间：`date -d @${old_time}`"
	echo "编译结束时间：`date -d @${new_time}`"
	echo "编译时长    ：$(((new_time-old_time+30)/60))分钟"
	echo
}

function set_ccache()
{
	prebuilts/misc/linux-x86/ccache/ccache -M 50G
}

function main()
{
	set_ccache
	set_env
	if [ ${TARGET} == "kernel" ]; then
		build_kernel
	elif [ ${TARGET} == "uboot" ]; then
		build_uboot
	elif [ ${TARGET} == "recovery" ]; then
		build_recovery
	elif [ ${TARGET} == "system" ]; then
		build_system
	else
		build_all
	fi
	copy_img
#	print_buildtime
}

main

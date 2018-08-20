#!/system/bin/sh

MARK=/data/local/symbol_apks_installed
PKGS=/data/misc/

install_others_apps()
{
    INSTALL_FILE=${PKGS}/INSTALL_LIST
    if [ -e $INSTALL_FILE ]; then
        cat ${INSTALL_FILE} | while read line
        do
        {
            /system/bin/pm install -r $line
        } &
        done

        return 1
    else
        return 0
    fi
}

copy_others_files()
{
    FILE_DIR=/mnt/sdcard/Pictures
    {
    /system/bin/cp -rf $PKGS/wallpaper/* $FILE_DIR/
    /system/bin/chmod 0666 $FILE_DIR/*
    } &
}

if [ ! -e $MARK ]; then
    echo "booting the first time, so pre-install some APKs."

#   copy_others_files
    install_others_apps
    find $PKGS -name "*\.apk" -exec sh /system/bin/pm install {} \;

# NO NEED to delete these APKs since we keep a mark under data partition.
# And the mark will be wiped out after doing factory reset, so you can install
# these APKs again if files are still there.
# busybox rm -rf $PKGS

    touch $MARK

    setprop persist.sys.install 1
    am broadcast -a action.roadrover.installapp.complete

    echo "OK, installation complete."
fi

am startservice -n com.iflytek.cutefly.speechclient/com.iflytek.autofly.SpeechClientService

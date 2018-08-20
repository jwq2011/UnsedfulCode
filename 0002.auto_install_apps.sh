#!/system/bin/sh

count=1
INSTALL_FILE=/data/INSTALL_LIST

cat ${INSTALL_LIST} | while read line
do
{
#    echo "Line $count:$line"
#    count=$[ $count + 1 ]
    /system/bin/pm install -r $line
}&
done

echo "finish"
exit 0

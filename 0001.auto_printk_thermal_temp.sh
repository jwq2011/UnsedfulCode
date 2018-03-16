#########################################################################
# File Name: auto_printk_thermal_temp.sh
# Author: kiwei
# Created Time: 2018年03月16日 星期五 14时58分51秒
#########################################################################

count=1

while [ $count ]; do
#	if [ $count == 6 ]; then
#		print_temp=$(cat /sys/devices/virtual/thermal/thermal_zone0/temp)
#		count=1
#		echo $print_temp
#	fi
	sleep 60
	echo "$(date):thermal_zone=$(cat /sys/devices/virtual/thermal/thermal_zone0/temp)"
#	count=$((count+1))
#	echo $count
done

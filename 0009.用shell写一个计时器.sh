

seconds_left=10
echo "请等待${seconds_left}秒……"

while [ $seconds_left -gt 0 ];do
	echo -n $seconds_left
	sleep 1
	seconds_left=$(($seconds_left - 1))
	echo -ne "\r     \r" #清除本行文字
done

#sleep 1s 表示延迟一秒  
#sleep 1m 表示延迟一分钟  
#sleep 1h 表示延迟一小时  
#sleep 1d 表示延迟一天    

#usleep : 默认以微秒。  
#1s = 1000ms = 1000000us

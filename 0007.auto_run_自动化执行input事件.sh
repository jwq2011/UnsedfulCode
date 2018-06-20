
# 自动化循环执行input事件并上报按键值
i=1

while [ $i -le "10000" ]; do

  echo $i

  #setting
  input tap 280 700

  #Connecteddevices
  input tap 388 388

  #Bluetooth
  input tap 633 246

  sleep 1

  #Bluetooth

  input tap 633 246

  #back

  input keyevent "KEYCODE_BACK"
  input keyevent "KEYCODE_BACK"

  i=`expr $i+ 1`

done

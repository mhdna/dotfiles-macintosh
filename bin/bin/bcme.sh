#!/bin/sh

precision=2        # number of digit for floating value
notify_time=20000  # number of milisecond the notification show

res=`echo "scale=$precision;$@" | bc`
notify-send -t $notify_time "$res" "=$@"

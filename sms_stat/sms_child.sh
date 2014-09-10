#!/bin/bash

if [ $# -lt 3 ]; then
echo "Usage $0: key(unicom) month(07) day(31)";
exit -1;
fi
key=$1
month=$2
day=$3
cd /home/webroot/app/log/sms
p=~/zhangjiuyun/$key
mkdir -p $p

for i in $(seq $day); do
i=$(printf "%02d" $i)
cat eucp2014-$month-$i.log |awk -F '900[1-2] ' '{print $2}'|awk '{if(length($1)>0 && length($1)<=5){print $1} else{print 1}}'|sort |uniq -c|awk 'BEGIN{SUM=0;}{SUM+=$1}{print $0}END{print SUM}' > $p/$i
#grep "||$key" eucp2014-$month-$i.log |awk -F '\\|\\|' '{print $7}'|sort |uniq -c|awk 'BEGIN{SUM=0;}{SUM+=$1}{print $0}END{print SUM}' >> $p/$i
done;

#!/bin/bash
if [ $# -lt 2 ]; then
echo "Usage $0: key(unicom) month(07), if month is 2,the 3rd arg is needed";
exit -1;
fi

dayofmonth[1]=31
dayofmonth[2]=$3
dayofmonth[3]=31
dayofmonth[4]=30
dayofmonth[5]=31
dayofmonth[6]=30
dayofmonth[7]=$3
dayofmonth[8]=31
dayofmonth[9]=30
dayofmonth[10]=31
dayofmonth[11]=30
dayofmonth[12]=31
key=$1
month=$2
day=${dayofmonth[10#$2]};

proot="~/zhangjiuyun/"
childcmd="sms_child.sh"

#分发到各机器上执行
for i in {00..03}; do
host=sms$i.qq
ssh $host "mkdir $proot";
scp $childcmd $host:$proot
ssh $host "cd $proot && sh $childcmd $key $month $day" &
done

wait

p="~/zhangjiuyun/$key/"
pdata="data/"
mkdir $pdata

#从各机器上scp结果回来
for j in $(seq $day); do
j=$(printf "%02d" $j)

    for i in {00..03}; do
    host=sms$i.qq
scp $host:$p$j $pdata$host"_"$j
    done

done;

#分析结果
presult="result/$key/"
mkdir -p $presult
for j in $(seq $day); do
j=$(printf "%02d" $j)
cat $pdata*_$j |awk 'NF>1{print $0}'|sort -n > t
awk '{a[$2]+=$1;}END{for(i in a){print i" "a[i];}}' t|awk 'BEGIN{print "type num"} SUM+=$2{print $0}END{print "sum "SUM}' >$presult$j
sed 's/ /,/g' $presult$j > $presult$j".csv"
rm -rf $presult$j
done;

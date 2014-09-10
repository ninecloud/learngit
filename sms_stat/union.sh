#!/bin/bash
res="result.csv"
cat 01.csv > $res
sed -i 's/num/01/g' $res

for i in {02..30}; do
    cat $i.csv|while read line; do
        key=$(echo $line|awk -F ',' '{print $1}')
        value=$(echo $line|awk -F ',' '{print $2}')
        lineno=$(grep -n "^"$key"," $res|awk -F ':' '{print $1}')
#echo "key:"$key" value:"$value" lineno:"$lineno
        if [ ! -z $lineno ]; then
            count=$(grep "^"$key"," $res|awk -F ',' '{print NF}')
            ii=10#$i
            let c=ii-count
            s=""
            for((j=1;j<=c;j++)); do
                s+=",0"
            done
            s+=","$value
#echo "s1:"$s

            sed -i ''$lineno's/$/'$s'/g' $res
        else
            ii=10#$i
            let c=ii-1
            s=$key
            for((j=1;j<=c;j++)); do
                s+=",0"
            done
            s+=","$value
            echo "s:"$s

            sed -i '$ a'$s'' $res
        fi
    done
    sed 's/num/'$i'/g' -i $res
done

sort -t',' -k 1,1n $res -o $res
sed '1{h;d};$G' -i $res
#sed '/sum/d' -i $res

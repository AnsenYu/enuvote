#!/bin/bash
enucli='/home/ubuntu/programs/enucli/enucli -u https://api.enumivo.com'
prod=$1
voters=$($enucli get table enumivo enumivo voters -l 1000 | egrep "$prod|owner" | grep -v "\"owner\": \"$prod\"" | grep -B 1 $prod| grep owner | awk -F "\"" '{print $4}')
voters="$voters $1"
sum=0
for vote in $voters
do
  stake=`$enucli get account $vote | egrep "staked:|delegated:" | awk 'BEGIN{x=0}{x = x + int($2);}END{print x}'`
  vo=`$enucli get account $vote | grep $prod | wc -l`
  if [ $vo = 1 ]; then
    echo "$vote -> $prod $stake"
    let sum+=stake
  fi
done

echo sum: $sum

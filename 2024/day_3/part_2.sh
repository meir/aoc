#!/bin/bash


mult() {
  echo $[$1 * $2]
}

filter() {
  dont=0
  sum=0
  while read line; do
    if [[ $line == "don't()" ]]; then
      dont=1
    elif [[ $line == "do()" ]]; then
      dont=0
    elif [[ $dont -eq 0 ]]; then
      parsed=$(echo $line | sed -E 's|[^0-9,]+||g' | sed 's|,| |g')
      result=$(mult $parsed)
      sum=$((sum + result))
    fi
  done

  echo $sum
}

cat ./input.txt | grep -o -e "mul([0-9]\+,[0-9]\+)" -e "don't()" -e "do()" | filter

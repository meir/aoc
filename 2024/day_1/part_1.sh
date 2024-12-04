#!/bin/bash

listA=()
listB=()

accumulate() {
  listA+=("$1")
  listB+=("$2")
}

# loop through lines in input
while read line; do
  accumulate $line
done <input.txt

sort_list() {
  list=("$@")
  IFS=$'\n' sorted=($(sort <<<"${list[*]}"))
  echo "${sorted[@]}"
}

listA=($(sort_list ${listA[@]}))
listB=($(sort_list ${listB[@]}))

distances=()
i=0
while [ $i -lt ${#listA[@]} ]; do
  distance=$((listA[$i] - listB[$i]))
  if [[ $distance -lt 0 ]]; then
    distance=$((distance * -1))
  fi
  distances+=($distance)
  ((i++))
done

sum=0
for i in ${distances[@]}; do
  sum=$((sum + i))
done

echo $sum

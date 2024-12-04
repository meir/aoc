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

similarity=()
i=0
while [ $i -lt ${#listA[@]} ]; do
  id=${listA[$i]}
  count=0
  for j in ${listB[@]}; do
    if [ $id -eq $j ]; then
      count=$((count + 1))
    fi
  done

  similarity+=($((id * count)))
  ((i++))
done

sum=0
for i in ${similarity[@]}; do
  sum=$((sum + i))
done

echo $sum

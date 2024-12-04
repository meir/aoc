#!/bin/bash

get_direction() {
  local A="$1"
  local B="$2"
  [[ $A -lt $B ]] && echo 1
  [[ $A -eq $B ]] && echo 0
  [[ $A -gt $B ]] && echo -1
}

in_range() {
  local A=$1
  local B=$2
  local min=1
  local max=3
  
  local diff=$((A - B))
  [ $diff -lt 0 ] && diff=$((diff * -1))
  [ $diff -ge $min ] && [ $diff -le $max ] && echo 1 || echo 0
}

is_sequence_safe() {
  local A=$1
  local B=$2
  
  if [[ $A -eq $B ]]; then
    return 1
  fi

  local direction=$(get_direction $A $B)
  if [ $sequence_direction -eq 0 ]; then
    sequence_direction=$direction
  elif [ $direction -ne $sequence_direction ]; then
    return 1
  fi

  if [ $(in_range $A $B) -eq 0 ]; then
    return 1
  fi

  return 0
}

is_safe() {
  local list=("$@")
  local safe=1
  local count=${#list[@]}
  sequence_direction=0

  local i=0
  while [ $i -lt $[$count - 1] ]; do
    local A=${list[$i]}
    local B=${list[$((i + 1))]}
    is_sequence_safe $A $B || safe=0
    ((i++))
  done
  
  return $[1-safe]
}

ignore_loop() {
  local list=("$@")
  local count=${#list[@]}
  local safe=0

  local i=0
  while [ $i -lt $[count] ]; do
    local rebuilt_list=(${list[@]:0:i} ${list[@]:$[i+1]:$count})
    is_safe ${rebuilt_list[@]} && return 0
    ((i++))
  done

  return 1
}

safe=0
while read line; do
  ignore_loop $line && ((safe++))
done <input.txt

echo $safe

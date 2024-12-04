#!/bin/bash

width=0
height=0
lines=()
while read line; do
  lines+=("$line")
  width=${#line}
  ((height++))
done <input.txt

get_y() {
  local line=$1
  echo ${lines[$line]}
}

get_x() {
  local n=$1
  local line=$2
  echo ${line:$n:1}
}

get() {
  get_x $1 $(get_y $2)
}

sequence="XMAS"

find() {
  local char=$1
  local x=$2
  local y=$3
  local dirx=$4
  local diry=$5
  
  if [ $char -eq ${#sequence} ]; then
    return 0
  fi

  if [ $x -lt 0 ] || [ $x -ge $width ]; then
    return 1
  fi

  if [ $y -lt 0 ] || [ $y -ge $height ]; then
    return 1
  fi

  local must=${sequence:$char:1}

  if [ ! $must = $(get $x $y) ]; then
    return 1
  fi

  local newx=$((x + dirx))
  local newy=$((y + diry))
  return $(find $((char + 1)) $newx $newy $dirx $diry)
}

sum=0
for ((y=0; y<height; y++)); do
  for ((x=0; x<width; x++)); do
    find 0 $x $y 1 0 && ((sum++))
    find 0 $x $y 0 1 && ((sum++))
    find 0 $x $y -1 0 && ((sum++))
    find 0 $x $y 0 -1 && ((sum++))
    find 0 $x $y 1 1 && ((sum++))
    find 0 $x $y 1 -1 && ((sum++))
    find 0 $x $y -1 -1 && ((sum++))
    find 0 $x $y -1 1 && ((sum++))
  done
done

echo $sum

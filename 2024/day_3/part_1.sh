#!/bin/bash


mult() {
  echo $[$1 * $2]
}

cat ./input.txt | grep -o 'mul([0-9]\+,[0-9]\+)' | sed -E 's|[^0-9,]+||g' | sed -E 's|,| |g' | while read line; do
  mult $line
done | awk '{s+=$1} END {print s}'

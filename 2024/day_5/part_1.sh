#!/bin/bash

accumulate_rules() {
  eval "rule_$1+=(\"$2\")"
}

find() {
  local page="$1"
  eval "echo \${rule_$page[@]}"
}

contains() {
  local value="$1"
  shift
  local before=("$@")
  for p in "${before[@]}"; do
    if [ "$p" = "$value" ]; then
      return 0
    fi
  done
  return 1
}

check() {
  local i=$#
  local before=()
  while [ $i -gt 0 ]; do
    local page=${!i}
    contains $page "${before[@]}" && return 1
    before+=($(find $page))
    i=$((i - 1))
  done

  return 0
}

middle() {
  local i=$#
  local center=$((i / 2 + 1))
  echo ${!center}
}

is_rules=true
sum=0
while read line; do
  if [ "$line" = "" ]; then
    is_rules=false
    continue
  fi

  if [ $is_rules = true ]; then
    inputs=$(sed 's/|/ /g' <<<"$line")
    accumulate_rules $inputs
  else
    inputs=$(sed 's/,/ /g' <<<$line)
    check $inputs && sum=$((sum + $(middle $inputs)))
  fi
done <input.txt

echo $sum

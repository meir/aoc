#!/bin/bash

# worst code here, i have no clue how i got here but it works (very very slowly)

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
  while [ $i -gt 0 ]; do
    local page=${!i}
    contains $page "${before[@]}" && return 1
    before+=($(find $page))
    i=$((i - 1))
  done

  return 0
}

rank() {
  local page_n=$1
  shift
  local pages=($@)
  local page=${pages[$page_n]}

  local i=0
  local before=($(find $page))
  local rank=0
  while [ $i -lt ${#pages[@]} ]; do
    contains ${pages[$i]} ${before[@]} && ((rank++))
    i=$((i + 1))
  done
  echo $rank
}

sort_list() {
  local rank=$#
  local output=()

  while [ $rank -ge 0 ]; do
    for page in "$@"; do
      local r=$(sed -E 's|,.*||g' <<<$page)
      local v=$(sed -E 's|.*,||g' <<<$page)
      if [ "$r" = "$rank" ]; then
        output+=("$v")
      fi
    done
    
    rank=$((rank - 1))
  done

  echo "${output[@]}"
}

lame_sort() {
  ranks=()
  local i=0
  local pages=($@)
  while [ $i -lt $# ]; do
    ranks+=("$(rank $i "$@"),${pages[$i]}")
    ((i++))
  done

  # echo ${ranks[@]}
  
  left=($(sort_list ${ranks[@]}))
}

fix() {
  output=()
  local i=0
  local left=($@)
  # echo "Initial value: ${left[@]}"
  while [ $i -lt $# ]; do
    lame_sort ${left[@]}
    # echo "After sort: ${left[@]}"

    local pop=${left[${#left[@]}-1]}
    output=("$pop" "${output[@]}")
    left=("${left[@]:0:${#left[@]}-1}")
    # echo "After pop, left=${left[@]}, output=${output[@]}"
    ((i++))
  done
  
  echo ${output[@]}
}

middle() {
  local i=$#
  local center=$((i / 2 + 1))
  echo ${!center}
}

is_rules=true
sum=0
counter=0
while read line; do
  if [ "$line" = "" ]; then
    is_rules=false
    continue
  fi

  if [ $is_rules = true ]; then
    inputs=$(sed 's/|/ /g' <<<"$line")
    accumulate_rules $inputs
  else
    ((counter++))
    echo "starting with #$counter"
    inputs=$(sed 's/,/ /g' <<<$line)
    before=()
    check $inputs || inputs=$(fix $inputs) sum=$((sum + $(middle ${inputs[@]})))
    echo "sum after #$counter: $sum"
  fi
done <input.txt

echo $sum

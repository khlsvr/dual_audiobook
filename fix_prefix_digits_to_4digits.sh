#!/bin/bash

for file in *_*.opus;
do  prefix=${file%%_*}  suffix=${file#*_}
  printf -v new_prefix "%04d" "$((10#$prefix))"
  new_file="${new_prefix}_${suffix}"
  mv -- "$file" "$new_file"
done

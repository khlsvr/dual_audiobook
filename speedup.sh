#!/bin/bash
input_directory="."
for file in *.opus; do
  ffmpeg -i "$file" -filter:a "atempo=1.3" -vn "temp_$file"
  mv "temp_$file" "$file"
done


#!/bin/bash

output_audio="final_audio.opus"
ru_dir="ru"
en_dir="en"

# Create an array of Russian and English clip files
ru_files=("$ru_dir"/*.opus)
en_files=("$en_dir"/*.opus)

# Ensure both arrays are the same length
num_ru_files=${#ru_files[@]}
num_en_files=${#en_files[@]}

if [ "$num_ru_files" -ne "$num_en_files" ]; then
  echo "The number of Russian and English clips does not match."
  exit 1
fi

# Create a temporary file to store the list of absolute file paths for merging
tmp_list_file=$(mktemp)
for ((i = 0; i < num_ru_files; i++)); do
  ru_file_path=$(realpath "${ru_files[$i]}")
  en_file_path=$(realpath "${en_files[$i]}")
  echo "file '$ru_file_path'" >> "$tmp_list_file"
  echo "file '$en_file_path'" >> "$tmp_list_file"
  echo "file '$ru_file_path'" >> "$tmp_list_file"
done

# Use FFmpeg to merge the clips based on the list
ffmpeg -f concat -safe 0 -i "$tmp_list_file" -c copy "$output_audio"

# Clean up the temporary list file
#rm "$tmp_list_file"


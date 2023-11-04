#!/bin/bash

audio_file="a.opus"
subtitle_file="e.vtt"

mkdir -p ru

counter=0

while IFS=' ' read -r start_time _ end_time; do
	filename="$(printf "%04d" $counter)_${start_time//:}.opus"
	ffmpeg -nostdin -i "${audio_file}" -ss "${start_time}" -to "${end_time}" -c copy "ru/${filename}"
	((counter++))
done < "$subtitle_file"

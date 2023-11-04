#!/bin/bash

timeop_ms() {
    h1=${1%:*:*}
    m1=${1%:*}
    m1=${m1#*:}
    s1=${1#*:*:}
    s1=${s1%.*}
    ms1=${1#*:*:*.}
    s=$((${h1#0} * 3600000 + ${m1#0} * 60000 + ${s1#0} * 1000 + 10#${ms1} + $2))
    result=$((s + $2))
    h2=$((result / 3600000))
    m2=$((result % 3600000 / 60000))
    s2=$((result % 60000 / 1000))
    ms2=$((result % 1000))
    printf '%02d:%02d:%02d.%03d\n' "$h2" "$m2" "$s2" "$ms2"
}

input_file="$1"
output_file="e.vtt"
timestamp=""

while IFS=' ' read -r start_time _ end_time; do

    if [[ $end_time =~ ^00 ]]; then
	echo $end_time
	# add 2s to end_time with value 1000
        modified_end_time=$(timeop_ms "$end_time" 1000)
        #echo "$start_time --> $modified_end_time" >> "$output_file"
        timestamp+="$start_time --> $modified_end_time"$'\n'
    fi
done < "$input_file"

#echo "Modified subtitles saved to $output_file"
echo -e "$timestamp" > "$output_file"


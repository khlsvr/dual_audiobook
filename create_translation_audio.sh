#!/bin/bash

# Define the input subtitle file
subtitle_file="a.vtt"

# Initialize a counter
counter=0

# Function to clean text for file naming
clean_text() {
    # Remove special characters and replace spaces with underscores
    cleaned_text=$(echo "$1" | tr -cd '[:alnum:]')
    echo "$cleaned_text"
}

# Read the subtitle file
while IFS= read -r line; do
    if [[ $line =~ ^[0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9] ]]; then
        # Start of a new entry
	check_text=$(echo "$entry_text" | tr -d ' ')
        if [ ! -z "$check_text" ]; then
            # Use ~~trans~~ mimic tool to generate audio
            filename=$(printf "%04d_%s" $counter "$(clean_text "$entry_text")")
	    filename="${filename:0:20}.wav"
	    
	    # problem. trans can only run up to 201 characters long string"
 	    #trans -download-audio-as "$filename" "$entry_text" -to en
            #mimic3 "hello how you doing?! I am fine" > test.wav
	    mimic3 --length-scale 0.8 "$entry_text" > $filename
	    counter=$((counter+1))
       
        else
   	    #filename=$(printf "%02d_silence.opus" $i)
            filename=$(printf "%04d_silence.opus" $counter )
            ffmpeg -f lavfi -i anullsrc=r=48000:cl=stereo -t 1 "$filename"
            counter=$((counter+1))
    	fi

        entry_text=""
    else
        # Collect lines within the entry
        entry_text="$entry_text $line"
    fi
done < "$subtitle_file"

	check_text=$(echo "$entry_text" | tr -d ' ')
        if [ ! -z "$check_text" ]; then
            # Use trans tool to generate Opus audio
            filename=$(printf "%04d_%s" $counter "$(clean_text "$entry_text")")
	    filename="${filename:0:20}.wav"
            #trans -download-audio-as "$filename" "$entry_text" -to en
	    mimic3 --length-scale 0.8 "$entry_text" > $filename
            counter=$((counter+1))
       
        else
   	    #filename=$(printf "%02d_silence.opus" $i)
            filename=$(printf "%04d_silence.opus" $counter )
            ffmpeg -f lavfi -i anullsrc=r=48000:cl=stereo -t 1 "$filename"
            counter=$((counter+1))
    	fi


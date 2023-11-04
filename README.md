# dual_audiobook
Convert audio+subtitles to audio+audio


== Creating a source audio + translation audio per each subtitle line from source audio + translation subtitle text with bunch of bash scripts with help of mimic tool (or trans tool) ==

1. Get the source audio + subtitle file. For example use filmot to search videos based on subtitles. https://filmot.com/captionLanguageSearch?titleQuery=%D0%B0%D1%83%D0%B4%D0%B8%D0%BE%D0%BA%D0%BD%D0%B8%D0%B3%D0%B0&channelID=&captionLanguages=en%20&capLangExactMatch=1  Then download the video file with for example extracting only audio with `yt-dlp -x <youtube url>` and then download its subtitle with `yt-dlp --skip-download --write-ubs <youtube url>` or such.

2. Prepare subtitle file by running sub_file_to_chop_format.sh. The script modifies the subfile to have only timestamp lines and increment end_time by 2s. Note (obsolete): fwiw this cmd removes all lines in subfile that do not start with string "00" (for under 1h audio): sed -n '/^00/p' a.vtt > b.vtt.

3. Chop the source audio file to pieces based on subtitle files' timestamp using the chop_source_audio.sh bash script. Adjust the script for source audio and subtitle file and output dir if necessary.

4. Create translation audio by creating first a subdir (default script files expect "en/" for dir name) for these files and then copying the create_translation_audio.sh and the non-modified subtitle file to the created subdir. Then edit the begin of the subtitle file in so that remove everything from the begin until the first actual subtitle text. Remove the preceding timestamp too. The first entry should not precede a timestamp. Then run the create_translation_audio.sh script. 

problem with trans (if not using mimic): trans takes only max 201 chars. Also check concat tmp list file if for example 89 is followed by 90 and not 890, otherwise add more preceding zeroes.

5. If the source audio in step 3 is in opus format, then we need to convert the translation audio from step 4. which is in wav format (if mimic3 used) to the opus format. Note, also if source is in wav, maybe it's not in the same hz etc and need to be converted.

Navigate to the translation audio dir and paste to create opus files.

for file in *.wav; do
  ffmpeg -i "$file" -c:a libopus -b:a 48k -ar 48000 -ac 2 -strict -2 "${file%.wav}.opus"
done 

Conversion may not work on long filenames. Renaming to first 20 chars maybe necessary: for file in *.mp3; do mv "$file" "$(echo "$file" | cut -c 1-20).mp3"; done. (Addressed in latest revision of create_transaltion_audio.sh)

6. We can speed up (by 1.3 for example) all the opus files in a directory in-place by running speedup.sh. The english audio speed with mimic can be controlled with --length-scale flag in create_translation_audio.sh for example.

7. Now as we have the source audio and translation audio pieces in their own subdirs, we can run the concat.sh file to concatenate the files into final audio file in the main dir. Make sure file listing (ls) has them in order by having enough preceding zeroes in filenames or otherwise we need to fix the prefix digits to more digits with fix script (or modify main scripts and rerun them)


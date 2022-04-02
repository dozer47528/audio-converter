#!/bin/bash

set -e
if [[ "$DEBUG" == "1" ]]; then
    set -x
fi

IFS=$'\n'
FORMATS_LIST=$(echo $SOURCE_VIDEO_FORMATS | tr "," "\n")

echo "audio converter start"

for format in $FORMATS_LIST
do
    for file in $(find "$TARGET" -type f -name "*.$format")
    do
        echo "analysing: $file"
        ffprobe_output=$(ffprobe "$file" 2>&1)
        audio_count=$(echo "$ffprobe_output" | grep "Audio: \w*," | wc -l)
        target_audio_count=$(echo "$ffprobe_output" | grep "Audio: $TARGET_AUDIO_FORMAT*," | wc -l)

        if [[ "$audio_count" != "$target_audio_count" ]]; then
            echo "processing: $file"
            echo "$ffprobe_output" | grep "Audio: \w*,"
            new_file=/tmp/$(basename "$file")
            ffmpeg -i "$file" -map 0:v -c:v copy -map 0:a -c:a ac3 -map 0:s -c:s copy -y "$new_file"
            chown --reference="$file" "$new_file"
            mv "$new_file" "$file"
        fi
    done
done

echo "audio converter finish"
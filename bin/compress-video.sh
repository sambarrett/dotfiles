#!/bin/sh

input_file="$1"
output_file="$2"

ffmpeg -i "$input_file" -c:v libx264 -preset slow -x264-params crf=22 -c:a libmp3lame -b:a 128k "$output_file"

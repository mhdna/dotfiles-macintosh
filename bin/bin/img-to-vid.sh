#!/bin/sh

ffmpeg -loop 1 -i "$1" -i "$2" \
    -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
    -c:v libx264 -pix_fmt yuv420p -tune stillimage -crf 28 \
    -c:a aac -b:a 128k \
    -t 52 \
    -shortest \
    -movflags +faststart \
    output.mp4

# ffmpeg -loop 1 -i "$1" -i "$2" \
#     -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
#     -c:v libx264 -pix_fmt yuv420p \
#     -preset veryslow -crf 34 -tune stillimage \
#     -c:a aac -b:a 64k \
#     -shortest \
#     -movflags +faststart \
#     output.mp4

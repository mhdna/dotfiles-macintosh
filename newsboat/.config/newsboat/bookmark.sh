#!/bin/sh

target="$NOTES_DIR/news_bookmarks.org"

# 1 URL, 2  Title, 3 Discription, 4 Feed name
echo "** $2
$1" >> $target # URL
[ -n "$3" ] && echo "$3" >> $target

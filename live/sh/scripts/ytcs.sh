#!/usr/bin/env  sh
# Scrape comments from YouTube videos
# For the commandline executable of youtube-comment-scraper:
#   https://github.com/philbot9/youtube-comment-scraper/
# https://blog.spiralofhope.com/?p=45279
#
# See  `youtube-comment-scraper.sh`  for a web-GUI version.



if [ -n "$1" ]; then
  source_video_id="$1"
  \echo  " * Downloading comments..."
#  \youtube-comment-scraper  --format csv  "$source_video_id"  >  comments-"$source_video_id".csv
  \youtube-comment-scraper  --format csv  --outputFile comments-"$source_video_id".csv  "$source_video_id"
else
  \youtube-comment-scraper  "$@"
fi

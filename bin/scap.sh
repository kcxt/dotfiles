#!/bin/bash

FILE=$(mktemp /tmp/XXXXXXXXXXXX.png)

grimshot save area $FILE;

#convert -auto-level $FILE $FILE-processed

if [ "$1" == "-u" ]; then
	URL=$(curl -F"file=@$FILE" https://0x0.st)
	echo $URL
	echo -n "$URL" | wl-copy
else
	if [ -z "$WAYLAND_DISPLAY" ]; then
		cat $FILE | xclip -i -selection clipboard -target image/png
	else
		wl-copy -t image/png < $FILE
	fi
fi

#!/bin/bash

FILE=$(mktemp /tmp/XXXXXXXXXXXX.png)

args="$*"

arg() {
	echo "$args" | grep -q "\-$1";
	return $?
}

# -w = capture window
if arg "w"; then
	grimshot save active $FILE
else
	grimshot save area $FILE;
fi

#convert -auto-level $FILE $FILE-processed

if arg "u"; then
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

notify-send "Screenshot taken $FILE"

# Delete the file in 90 seconds
nohup sh -c "sleep 90; rm -f $FILE" 2>/dev/null & disown


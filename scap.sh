#!/bin/bash

FILE=$(mktemp /tmp/XXXXXXXXXXXX.png)

gnome-screenshot -acf $FILE;

if [ "$1" == "-u" ]; then
	chmod 666 $FILE
	scp $FILE s.calebs.dev:/var/screenshots/ &
	echo -n "https://s.calebs.dev/$(basename $FILE)" | xclip -sel  clip
else
	cat $FILE | xclip -i -selection clipboard -target image/png
fi

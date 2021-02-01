#!/bin/bash

gnome-screenshot -acf /tmp/screenshot.png && cat /tmp/screenshot.png | xclip -i -selection clipboard -target image/png

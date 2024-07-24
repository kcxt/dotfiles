#!/bin/bash
# Enable floating for windows with the matching class
# that have a non-null 'transient_for' window properties
# This implies they are a child window

regexp="$1"
class=$(swaymsg -t get_tree | jq -r ".. | ((.nodes + .floating_nodes)? // empty)[] | select(.window_properties.class | test(\"$regexp\"; \"gi\")) | .window_properties.class")


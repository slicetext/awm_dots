#!/usr/bin/env bash
mute=$(pactl get-sink-mute 0)
if [ "$mute" = "Mute: no" ]; then
	echo $(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')%
else
	echo "Muted"
fi

#!/bin/bash
STEP="${1:-5}"
DIRECTION="$2"

if command -v notify-send >/dev/null; then
    if [ "$DIRECTION" = "up" ]; then
        brightnessctl -q set +"$STEP"% 
    else
        brightnessctl -q set "$STEP"%-
    fi

    VALUE=$(brightnessctl --percentage get)
    notify-send -e -h string:x-canonical-private-synchronous:brightness \
        -h "int:value:$VALUE" -t 800 "Brightness: ${VALUE}%"
else
    brightnessctl -q set "$([ "$DIRECTION" = "up" ] && echo + || echo -)${STEP}%"
fi

    
		    

	
	
	

  

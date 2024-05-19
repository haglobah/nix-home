#!/usr/bin/env bash

execCommand=$1
className=$2

running=$(hyprctl -j clients | jq -r ".[] | select(.class == \"${className}\")")
echo $running

if [[ $running == "" ]]
then
	echo "start"
	hyprctl dispatch exec ${execCommand} & 
	hyprctl dispatch movetoworkspace special:${className}
else 
	echo "toggle special"
	hyprctl dispatch togglespecialworkspace ${className}
fi
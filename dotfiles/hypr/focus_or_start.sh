#!/usr/bin/env bash

execCommand=$1
className=$2

running=$(hyprctl -j clients | jq -r ".[] | select(.class == \"${className}\")")
echo $running

if [[ $running != "" ]]
then
	echo "focus"
	hyprctl dispatch focuswindow ${className}
else 
	echo "start"
	hyprctl dispatch exec ${execCommand} & 
fi
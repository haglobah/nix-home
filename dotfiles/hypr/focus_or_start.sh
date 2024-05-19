#!/usr/bin/env bash

execCommand=$1
className=$2
workspaceOnStart=$3

running=$(hyprctl -j clients | jq -r ".[] | select(.class == \"${className}\")")
echo $running

if [[ $running != "" ]]
then
	echo "focus"
	hyprctl dispatch focusWindow pid:$(pidof -s ${execCommand})
else 
	echo "start"
	hyprctl exec ${execCommand} & 
fi
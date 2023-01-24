#!/bin/sh

setxkbmap se

# Start up services
exec i3
exec dunst &

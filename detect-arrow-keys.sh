#!/bin/bash

# Code for detecting arrow keys

readonly KEYBOARD_UP=$'\e[A' KEYBOARD_DOWN=$'\e[B' KEYBOARD_RIGHT=$'\e[C' KEYBOARD_LEFT=$'\e[D'



while true; do
    read -n 3 -p "Press any of the arrow keys: "
    case $REPLY in
        $KEYBOARD_UP) echo "Up arrow pressed!";;
        $KEYBOARD_DOWN) echo "Down arrow pressed!";;
        $KEYBOARD_RIGHT) echo "Right arrow pressed!";;
        $KEYBOARD_LEFT) echo "Left arrow pressed!";;
        *) echo "I didn't like that";;
        
    esac
done
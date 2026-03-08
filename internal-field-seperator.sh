#!/bin/sh

echo this program displays how the Internal Field Seperator \(IFS\) "feature" works

oldIFS=$IFS

echo "right now the IFS is \"$IFS\""

echo -n To test how it works, just enter 3 inputs and seperate them with space like \(x y z\)\: ; read x y z; echo you get \"x\" is \"$x\"\; \"y\" is \"$y\"\; \"z\" is \"$z\"\; 

IFS=:

echo "The IFS has now been set to \"$IFS\""

echo -n Therefore if you put \":\" inbetween your inputs like \(x\:y\:z\)\: ; read x y z; echo you get \"x\" is \"$x\"\; \"y\" is \"$y\"\; \"z\" is \"$z\"\; 
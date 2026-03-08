#!/bin/sh
X=0
while [[ -n $X ]]; do
	echo -n ">>> "; read X
	echo $X
done
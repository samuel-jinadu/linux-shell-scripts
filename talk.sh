#!/bin/sh

echo You see a door at the end of the corridor with a little gap in it and the title 
echo "\"He thought he could leave me, MEEE!! THE CRIMSON MATRIACH!!! BOURNE, ROT FOR ETERNITY\""
echo "Bourne the Broken:" "pLeAsEee... sPeAk tO mEeE!!!"
while : 
do
	echo -n "You: "; read input
	case "$input" in
		hello | hi | hey) echo "Bourne the Broken:" "yEsSs yEsSs yEsSsSsS!!" "*rises";;
		bye ) echo "Bourne the Broken:" "nOoo pLeAsEee wAiT!!!" "*vomits black sewer-smelling liquid"; break;;
		* ) echo "Bourne the Broken:" "mOrEE sAy mOrEEE... mY fReEdOm iS aT hAnDDD!!";;
	esac

done
echo You have avoided disaster by refusing to free Bourne the Broken
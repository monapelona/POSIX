#!/bin/bash

curl http://cbi.ucaribe.edu.mx:8080/~jeae/final/musica.mp3 > archivo.mp3

curl http://cbi.ucaribe.edu.mx:8080/~jeae/final/info.txt > texto.txt

curl http://cbi.ucaribe.edu.mx:8080/~jeae/final/portada.jpg > portada.jpg

ARTIST=$( cat texto.txt | head -n 1 | cut -d ":" -f 2 | tr -d "'" )

ALBUM=$( cat texto.txt | head -n 2 | tail -n 1 | cut -d ":" -f 2 | tr -d "'" )

YEAR=$( cat texto.txt | head -n 3 | tail -n 1 | cut -d ":" -f 2 | tr -d "'" )

GENRE=$( cat texto.txt | head -n 4 | tail -n 1 )

GENRE2=$( id3 -L | grep -i "$GENRE" | cut -d ":" -f 1 | tr -d "'" )

COMMENT=$( cat texto.txt | head -n 5 | tail -n 1 | cut -d ":" -f 2 | tr -d "'" )

NUM=$( cat texto.txt | grep -i "|" | cut -d "|" -f 1 | wc -l | tr -d "'")

CON=1

while [ $CON -le $NUM  ]

do

 NOM=$( cat texto.txt | grep -i "|" | cut -d "|" -f 2 | head -n $CON | tail -n 1 | tr -d "'" )
 A=$(cat texto.txt | grep -i "|" | cut -d "|" -f 3 | head -n $CON | tail -n 1)
 MIN=$(echo $A | cut -d ":" -f 1)
 SEG=$(echo $A | cut -d ":" -f 2)
 RES=$( expr $MIN \* 60 + $SEG)
 sox archivo.mp3 $CON.mp3 trim 0:$FIN.0 0:$RES.0
 FIN=$( expr $FIN + $RES)

 mv $CON.mp3 "$NOM".mp3

 lame --ti portada.jpg "$NOM".mp3

 rm "$NOM".mp3

 mv "$NOM".mp3.mp3 "$NOM".mp3

 id3 -t "$NOM" -T $CON -a "$ARTIST" -A "$ALBUM" -g $GENRE2 -y $YEAR -c "$COMMENT" "$NOM".mp3

 let "CON += 1"

done

sqlite3 Musica.db "create table Musica(ARTIST, ALBUM, YEAR, GENRE, COMMENT, TRACK, TITLE, DURATION);"

CON=1

while [ $CON -le $NUM ]
do

 NOM=$( cat texto.txt | grep -i "|" | cut -d "|" -f 2 | head -n $CON | tail -n 1 )

 DURATION=$( cat texto.txt | grep -i "|" | cut -d "|" -f 3 | head -n $CON | tail -n 1 )

 sqlite3 Musica.db "insert into Musica(ARTIST, ALBUM, YEAR, GENRE, COMMENT, TRACK, TITLE, DURATION) values('$ARTIST','$ALBUM','$YEAR','$GENRE','$COMMENT','$CON','$NOM','$DURATION');"

let "CON += 1"

done


#!/bin/bash

curl http://cbi.ucaribe.edu.mx:8080/~jeae/final/musica.mp3 > rolitas.mp3

curl http://cbi.ucaribe.edu.mx:8080/~jeae/final/portada.jpg > albumcover.jpg

curl http://cbi.ucaribe.edu.mx:8080/~jeae/final/info.txt > infoalbum.txt


#En la varibale 'NUM_CANCIONES' guardaremos el número de canciones que contenga el archivo que nos proporcionen.
#En este caso como se nos proporcionó un archivo de texto, y queremos saber la cantidad de canciones, utilizamos el
#comando 'grep' con la opción '-i ' para que descarte a las filas de texto que carezcan de '|' y contamos las lineas con 'wc -l'

NUM_CANCIONES=$( cat infoalbum.txt | grep -i "|" | wc -l)

#echo $NUM_CANCIONES

#A continuación procedemos a iniciar un ciclo 'FOR' para conocer los minutos y segundos de duración de cada canción

BEGIN=0

for (( i = 1; i <= $NUM_CANCIONES; i++ )); 

do
	#Del archivo infoalbum.txt exluimos a todos los registros que no tengan '|' y tomamos todo lo que está a la 
	#izquierda de ":", pero necesitamos sólo la duración de cada canción por lo que necesitamos cortar todo lo que está a la izquiera 
	#poniendo como delimitador al pipe '|' en el campo 3
  MINUTE=$( cat infoalbum.txt | grep -i "|" | cut -d "|" -f 3 | cut -d ":" -f 1 | head -n $i | tail -n 1)

  #echo $MINUTE  

#Para el caso de los segundos, vamos a tomar lo que está después de ':' 
SECOND=$( cat infoalbum.txt | grep -i "|" | cut -d ":" -f 2 | head -n $i | tail -n 1 )

 #echo $SECOND

#Ahora el contenido de la variable 'MINUTE' lo pasaremos a segundos para 
#posteriormente sumarlo a los segundos que ya teníamos, que se encuentran en la variable 'SECOND'
MIN_TO_SEC=$( expr $MINUTE \* 60 )
  
  #echo $MIN_TO_SEC  

  #Procedemos a hacer la suma de los minutos convertidos a segundos y los segundos que ya se tenían
  ENDTRACK=$(expr $MIN_TO_SEC + $SECOND)

  #echo $TIME 
  
  #Una vez teniendo el tiempo dado en segundos procedemos a cortar el archivo MP3 que nos proporcionaron 
  #Para ello tendremos que declarar una variable de inicio 'TRACK' para indicar cuando comienza la cancion
  #y utilizamos la variable 'TIME' para indicar donde finaliza.
  sox rolitas.mp3 $i.mp3 trim 00:$BEGIN.0 00:$ENDTRACK.0

  #Aquí se suman los tiempos de inicio y de fin de cada canción, para que sea el inicio de la siguiente canción
  BEGIN=$(expr $BEGIN + $ENDTRACK) 

  #Ahora asignaremos la portada del album a cada canción 
  lame --ti albumcover.jpg $i.mp3 

  
  #Para poder hacer las etiquetas para cada canción tomamos la información necesaria del campo en 
  #que se encuentre y la guardamos en una variable
  INTERPRETE=$( cat infoalbum.txt | grep "ARTIST" | cut -d ":" -f 2 )
  ALBUM=$( cat infoalbum.txt | grep "ALBUM" | cut -d ":" -f 2 )  
  ANIO=$( cat infoalbum.txt | grep "YEAR" | cut -d ":" -f 2 )
  COMENTARIO=$( cat infoalbum.txt | grep "COMMENT" | cut -d ":" -f 2 )
  GENERO=$( cat infoalbum.txt | grep "GENRE" | cut -d ":" -f 2 )
  TRACK=$( cat infoalbum.txt | grep -i "|" | cut -d "|" -f 1 | head -n $i | tail -n 1 )
  TITLE=$( cat infoalbum.txt | grep -i "|" | cut -d "|" -f 2 | head -n $i | tail -n 1 ) 
  
  mv "$i".mp3.mp3 "$i".mp3
  
  #Procedemos a poner las etiquetas a cada canción del album
  id3 -a "$INTERPRETE" -A "$ALBUM" -y "$ANIO" -g "$GENERO" -c "$COMENTARIO" -T "$TRACK" -t "$TITLE" "$i".mp3 


done


#A continuación procedemos a cargar la información recopilada en una base de datos
  sqlite3 musica.db "create table musica(ARTIST, ALBUM, YEAR, GENRE, COMMENT, TRACK, TITLE, DURATION);"

  for (( j = 1; j <= $NUM_CANCIONES; j++ )); 
  do
   
  #Para la base de datos necesitamos tomar el nombre de la cancion y la duración 
  CANCION=$( cat infoalbum.txt | grep -i "|" | cut -d "|" -f 2 | head -n $j | tail -n 1 )
  DURACION=$( cat infoalbum.txt | grep -i "|" | cut -d "|" -f 3 | head -n $j | tail -n 1 )

   #Eliminamos la comilla simple de las cacniones y del nombre del artista
   NOMBRE_CANCION=$( echo "$CANCION" | tr -d "'" )
   NOMBRE_ARTISTA=$( echo "$INTERPRETE" | tr -d "'")


   sqlite3 musica.db "insert into musica values('$NOMBRE_ARTISTA', '$ALBUM', '$YEAR', '$GENERO', '$COMENTARIO', '$j', '$NOMBRE_CANCION', '$DURACION');"

  	
  done

  rm rolitas.mp3 infoalbum.txt albumcover.jpg
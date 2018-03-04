 #!/bin/bash


ENLACE=$( curl http://cbi.ucaribe.edu.mx:8080/~jeae/datos/15_alimentacion_01_qroo.csv )
LISTA=$( echo "$ENLACE" | head -404 | tail -396 ) #En esta línea estoy asignando a LISTA el cuerpo del reporte
 

#Invoco a la variable LISTA desde la variable NUM_ENCUESTA para que cuente las lineas


NUM_ENCUESTA=$( echo "$LISTA" | wc -l ) 

#Durante la ejecucion de este script me esta dando problemas la obtencion de la fecha asi que voy a probar correr el script 
#Tratando de dar salida unicamente a la variable DATE


#FECHA_PRUEBA=$( curl http://cbi.ucaribe.edu.mx:8080/~jeae/datos/15_alimentacion_01_qroo.csv | head -2 | tail -1 | cut -d : -f 2 | cut -d , -f 1 )
#echo "$FECHA_PRUEBA" 


#DEspues de haber hecho esta prueba llegue a la conclusion de que la expresion de abajo es la correcta 

DATE=$( echo "$ENLACE" | head -2 | tail -1 | cut -d : -f 2 | cut -d , -f 1 ) 

       for i in `seq 1 $NUM_ENCUESTA`  #Iniciamos el ciclo for para que cuente desde la primera linea hasta el límite de datos que tiene el archivo
       do

       		#Procedemos a obtener los campos de cada registro 
            
            ESTADO=$( echo "$LISTA" | head -$i | tail -1 | cut -d "," -f 1 )
            MUNICIPIO=$( echo "$LISTA" | head -$i | tail -1 | cut -d "," -f 2 )
     		SIT_ALIMENT=$( echo "$LISTA" | head -$i | tail -1 | cut -d "," -f 3 )
     		EST_ALIMENT=$( echo "$LISTA" | head -$i | tail -1 | cut -d "," -f 4 )
     		HOGARES=$( echo "$LISTA" | head -$i | tail -1 | cut -d "," -f 5 )
     		LIM_ALIMENT=$( echo "$LISTA" | head -$i | tail -1 | cut -d "," -f 6 )
     		NO_LIMIT_ALIMENT=$( echo "$LISTA" | head -$i | tail -1 | cut -d "," -f 7 )
     		NONESPECIFIC=$( echo "$LISTA" | head -$i | tail -1 | cut -d "," -f 8 )

     		#Una ves que hemos obtenido todos los campos de la encuesta los desplegamos como ordenes
     		#De SQL que bien se pueden aplicar como entrada a un procedimiento almacenado  
     
     		echo "Insert INTO Poblacion VALUES ('$DATE', '$ESTADO','$MUNICIPIO','$SIT_ALIMENT','$EST_ALIMENT','$HOGARES','$LIM_ALIMENT','$NO_LIMIT_ALIMENT',
       		'$NONESPECIFIC')"
        done


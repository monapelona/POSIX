#!/bin/bash 
curl http://cbi.ucaribe.edu.mx:8080/~jeae/cgi-bin/posix.cgi?160300006 > posix.rar 
unrar e posix.rar
pngtopnm sprite01.png > sprite01.pnm 
pngtopnm -a sprite01.png > sprite01.pgm 
jpegtopnm background02.jpg > background02.pnm


# A continuacion cortamos el sprite utilizando el comando pnmcut
# Y guardamos las imágenes ya cortadas en otros archivos pnm y por cada pnm hacemos su pgm 
# correspondiente para que haya un espacio en blanco en donde va la figura 

pnmcut 0 0 120 0 sprite01.pnm > monito01.pnm 
pnmcut 0 0 120 0 sprite01.pgm > monito01.pgm 
pnmcut 120 0 143 0 sprite01.pnm > monito02.pnm 
pnmcut 120 0 143 0 sprite01.pgm > monito02.pgm 
pnmcut 264 0 104 0 sprite01.pnm > monito03.pnm 
pnmcut 264 0 104 0 sprite01.pgm > monito03.pgm 
pnmcut 363 0 144 0 sprite01.pnm > monito04.pnm 
pnmcut 363 0 144 0 sprite01.pgm > monito04.pgm 
pnmcut 507 0 152 0 sprite01.pnm > monito05.pnm 
pnmcut 507 0 152 0 sprite01.pgm > monito05.pgm 
pnmcut 657 0 101 0 sprite01.pnm > monito06.pnm 
pnmcut 657 0 101 0 sprite01.pgm > monito06.pgm 

# Nuevamente tomo las imágenes que ya había cortado previamente y las volteo
# para que corra de acuerdo al sentido que se especifíca (izquierda-derecha) y viceversa

pnmcut 0 0 120 0 sprite01.pnm | pnmflip -lr > monito011.pnm
pnmcut 0 0 120 0 sprite01.pgm | pnmflip -lr > monito011.pgm
pnmcut 120 0 143 0 sprite01.pnm | pnmflip -lr > monito022.pnm
pnmcut 120 0 143 0 sprite01.pgm | pnmflip -lr > monito022.pgm 
pnmcut 264 0 104 0 sprite01.pnm | pnmflip -lr > monito033.pnm 
pnmcut 264 0 104 0 sprite01.pgm | pnmflip -lr > monito033.pgm 
pnmcut 363 0 144 0 sprite01.pnm | pnmflip -lr > monito044.pnm 
pnmcut 363 0 144 0 sprite01.pgm | pnmflip -lr > monito044.pgm 
pnmcut 507 0 152 0 sprite01.pnm | pnmflip -lr > monito055.pnm 
pnmcut 507 0 152 0 sprite01.pgm | pnmflip -lr > monito055.pgm 
pnmcut 657 0 101 0 sprite01.pnm | pnmflip -lr > monito066.pnm 
pnmcut 657 0 101 0 sprite01.pgm | pnmflip -lr > monito066.pgm

# Utilizamos el comando pnmcomp para unir dos imágenes con la opción align o xoff para especificar la posición 
# en el eje horizontal, y yoff o valign para la posición en el eje de las y's  


pnmcomp	-xoff=0 -v bottom -a=monito01.pgm monito01.pnm background02.pnm > m1.pnm
pnmcomp -xoff=300 -v bottom -a=monito02.pgm monito02.pnm background02.pnm > m2.pnm
pnmcomp -xoff=600 -v bottom -a=monito03.pgm monito03.pnm background02.pnm > m3.pnm
pnmcomp -xoff=850 -v bottom -a=monito04.pgm monito04.pnm background02.pnm > m4.pnm
pnmcomp -xoff=1200 -v bottom -a=monito05.pgm monito05.pnm background02.pnm > m5.pnm
pnmcomp -xoff=1500 -v bottom -a=monito06.pgm monito06.pnm background02.pnm > m6.pnm


mkdir examentools 
rm sprite01.png LEAME.TXT background02.jpg > examentools 


# Convertimos todos los archivos pnm a gif y los ordenamos del último al primero para que 
# el gif siga el sentido de izquiera a derecha 

convert -delay 20 -loop 0 m6.pnm m5.pnm m4.pnm m3.pnm m2.pnm m1.pnm psx01.gif

# Redirigimos las misma coordenadas planteadas anteriormente a otro archivo para 
# hacer la segunda animacion 

pnmcomp	-xoff=0 -v bottom -a=monito011.pgm monito011.pnm background02.pnm > m11.pnm
pnmcomp -xoff=300 -v bottom -a=monito022.pgm monito022.pnm background02.pnm > m22.pnm
pnmcomp -xoff=600 -v bottom -a=monito033.pgm monito033.pnm background02.pnm > m33.pnm
pnmcomp -xoff=850 -v bottom -a=monito044.pgm monito044.pnm background02.pnm > m44.pnm
pnmcomp -xoff=1200 -v bottom -a=monito055.pgm monito055.pnm background02.pnm > m55.pnm
pnmcomp -xoff=1500 -v bottom -a=monito066.pgm monito066.pnm background02.pnm > m66.pnm


# Convertimos nuevamente los archivos .pnm a .gif y los ordenamos del primero al último para que 
# siga el sentido de derecha a izquierda

convert -delay 20 -loop 0 m11.pnm m22.pnm m33.pnm m44.pnm m55.pnm m66.pnm psx02.gif

# Guardamos ambos gifs en un solo archivo 

convert psx02.gif psx01.gif posix.gif

# Por último comprimimos el gif que se generó  

rar a posix posix.gif  
















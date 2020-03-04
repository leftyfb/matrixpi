#!/bin/bash

timeout=10
brightness=100

ledmatrix(){
	sleep .1
	timeout $timeout /home/pi/rpi-rgb-led-matrix/utils/led-image-viewer --led-gpio-mapping=adafruit-hat --led-brightness=$brightness -C $@
}

images="/home/pi/images/"

pi(){
	timeout=1
	ledmatrix $images/pi-black.png 
	timeout=10
}

space(){
	ledmatrix -f $images/space_invaders.gif
}

digdug(){
	ledmatrix -f -D 150 $images/digdug.gif
}

funcs=$(compgen -A function|egrep -v "pi|ledmatrix")

while true; do
	for animation in $funcs ; do
		$animation
		pi
	done
done

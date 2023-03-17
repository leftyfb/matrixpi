#!/bin/bash

api_key=
zipcode=
timeout=10
prev_hour=0
home=/home/pi/
matrixpi=$home/matrixpi
images="$matrixpi/images/"
weather_icons="/$matrixpi/weather_icons"

[ ! -d $images ] && mkdir $images
[ ! -d $weather_icons ] && mkdir $weather_icons

# our main command to send pictures and animations for the LED panel
ledmatrix(){
	sleep .1
	timeout $timeout $home/rpi-rgb-led-matrix/utils/led-image-viewer --led-gpio-mapping=adafruit-hat --led-brightness=$brightness -C $@
}

weather(){
	# check for api_key and zipcode settings. skip weather function if either is not set
	[ -v $api_key ] && return 0
	[ -v $zipcode ] && return 0
        # grab temperature and weather icon every hour
        if [ $cur_hour != $prev_hour ] && (( $cur_hour % 3 == 0 )) ; then
		[ -f $weather_icons/temperature.png ] && rm $weather_icons/temperature.png 2>/dev/null
		[ -f $weather_icons/out.png ] && rm $weather_icons/out.png 2>/dev/null
                echo "time changed .... time to do things ...."
                read temp icon < <(echo $(curl -s "http://api.weatherstack.com/current?access_key=${api_key}&query=${zipcode}&units=f" | jq -r '.current.temperature, .current.weather_icons[0]'))
                icon_filename=$(basename $(echo $icon))
                echo "temperature = ${temp}F"
                echo "weather_icon = $weather_icons/$icon_filename"
                # cache weather icon
                [ ! -f $weather_icons/$icon_filename ] && wget -q $icon -P $weather_icons/
		# overlay temperature on downloaded weather icon
		convert -background '#0009' -fill white -stroke white -pointsize 22 +antialias label:"${temp}F" -gravity South -size 64,64 $weather_icons/temperature.png
		convert -composite -geometry +30+45 $weather_icons/$icon_filename $weather_icons/temperature.png $weather_icons/out.png
	else
			echo "we only run every 3 hours"
        fi
        timeout=10
	echo "display out.png"
        ledmatrix $weather_icons/out.png
}

# add picture and animation functions here

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

# start looping though all picture/animation funtions
while true; do
	cur_hour=$(date +%H)
	funcs=$(compgen -A function|egrep -v "pi|ledmatrix|weather"|sort -R)
	for animation in $funcs ; do
		hour=$(date +%H)
		# dim LED to 30% between 11pm and 5am
		if [ "$hour" -ge "23" ] || [ "$hour" -lt "7" ] ;then
			sleep 10
			break
		else
			brightness=100
		fi
		# display weather between animations
		weather
		echo "[$animation] running at $brightness brightness"
		$animation
		prev_hour=$cur_hour
	done
done

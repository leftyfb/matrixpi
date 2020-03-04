32x32 LED Matrix display

Requirements:

Raspberry Pi - https://www.adafruit.com/product/3055
32x32 RGB Matrix Panel - https://www.sparkfun.com/products/14646
12V Power adapter - I went with a 4A power adapter I had laying around
10x10 shadowbox - https://www.michaels.com/black-extra-deep-shadowbox-10x10-studio-decor/10229048.html
3D printed corner mounts - https://www.thingiverse.com/thing:4200106
rpi-rgb-led-matrix - https://github.com/hzeller/rpi-rgb-led-matrix

I included the rpi-rgb-led-matrix repo here just in case the project goes away but feel free to clone it directly from github. Either way you'll have to build/install rpi-rgb-led-matrix using the instructions provided with the project.

Once you've got rpi-rgb-led-matrix installed, add the led-matrix.service service with:
sudo systemctl enable /home/pi/led-matrix.service

Edit the led_script.bash to your liking

![Image description](https://lh3.googleusercontent.com/HhpxGvmw7vmEbX8zxnuxBtZDYuEHyW6twBPieB6tmW3tL-B6edxm3uFcogYKzpSlKJDICxD7bXlx4miF-zojeMUuPn8M9yUf27J6eJOMIF1HmJD2jX9tQwEg5lGQFTIG3xgQck9XHUc=w530-h706-no)

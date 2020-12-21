#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}

sudo apt update

#Installing dependencies
sudo apt -y install libfontconfig-dev qt5-default automake mercurial libtool libfreeimage-dev \
libopenal-dev libpango1.0-dev libsndfile-dev libudev-dev libtiff5-dev libwebp-dev libasound2-dev \
libaudio-dev libxrandr-dev libxcursor-dev libxi-dev libxinerama-dev libxss-dev libesd0-dev \
freeglut3-dev libmodplug-dev libsmpeg-dev libjpeg-dev libogg-dev libvorbis-dev libvorbisfile3 libcurl4 cmake aria2 lolcat figlet || error "Failed to install dependencies"

#Downloading SDK libraries
figlet Downloading SDK libraries | lolcat
sudo rm -r ~/temp  
mkdir ~/temp || error "Failed to create temp folder"
cd ~/temp || exit

#currently in ~/temp
hg clone http://hg.libsdl.org/SDL || error "Failed to clone SDL Libraries" #Cloning SDL Libraries 

cd ~/temp/SDL || exit

#currently in ~/temp/SDL
./autogen.sh || error "Failed to execute autogen.sh"

./configure --disable-pulseaudio --disable-esd --disable-video-wayland \
  --disable-video-opengl --host=arm-raspberry-linux-gnueabihf --prefix=/usr

#Compiling SDK Libraries with make
figlet Compiling SDL Libraries | lolcat
make || error "Failed to compile SDK Libraries"
sudo make install || error "Failed to Compile SDK Libraries"
cd ~/temp || exit #Coming out of SDL Folder

#Downloading and extracting the 3 addons
figlet Installing the 3 addons | lolcat

cd ~/RPIDoom3Installer/SDL
sudo dpkg -i sdl2-image_2.0.5-1_armhf.deb
sudo dpkg -i sdl2-mixer_2.0.4-1_armhf.deb
sudo dpkg -i sdl2-ttf_2.0.15-1_armhf.deb


figlet Installing dhewm3 | lolcat

sudo rm -r ~/temp/dhewm3  #Removing repository if it is already clone
cd ~/temp
git clone https://github.com/dhewm/dhewm3 ~/temp/dhewm3 || error "Failed to clone dhewm3 from github" #Cloning dhewm3 repository
cd ~/temp/dhewm3/neo/ || exit


#currently in ~/temp/dhewm3/neo  

sudo rm -r ~/temp/dhewm3/neo/build
mkdir ~/temp/dhewm3/neo/build || error "Failed to create build folder"
cd ~/temp/dhewm3/neo/build || exit
cmake ..  || error "Failed to build dhewm3"
make -j4  || error "Failed to build dhewm3"


Yes_Downloading_torrent () {
  figlet Downloading Game Files | lolcat
  cd ~/RPIDoom3Installer
  sudo rm -r ~/RPIDoom3Installer/Doom3DemoGameFiles.zip
  wget https://github.com/techcoder20/RPIDoom3Installer/releases/download/v1.0.0/Doom3DemoGameFiles.zip -P ~/RPIDoom3Installer || error "Failed to download game files"
  unzip ~/RPIDoom3Installer/Doom3DemoGameFiles.zip || error "Failed to extract game files"
  cd ~/temp/dhewm3/neo/build/ || exit
  cp base.so d3xp.so dhewm3 libidlib.a ~/RPIDoom3Installer/Doom3Demo || error "Failed to copy necessary files to Doom3DemoGameFile Folder"
  cp ~/RPIDoom3Installer/Doom3Demo.desktop ~/Desktop || error ""
}

No_Downloading_torrent () {
  mkdir ~/Doom3GameFiles || error "Failed to create Doom3GameFiles Folder"
  figlet -w 90 Please place the game files in ~/Doom3GameFiles | lolcat 
  cd ~/temp/dhewm3/neo/build/ || exit
  cp base.so d3xp.so dhewm3 libidlib.a ~/Doom3GameFiles || error "Failed to copy necessary files to Doom3GameFile Folder"
}

while true; do
    read -p  "Do you have the game files [Y/n]?" yn
    case $yn in
        [Yy]* ) No_Downloading_torrent; exit;;
        [Nn]* ) Yes_Downloading_torrent; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


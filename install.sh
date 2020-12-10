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
rm -r ~/temp  
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
figlet Compiling SDK Libraries | lolcat
make || error "Failed to compile SDK Libraries"
sudo make install || error "Failed to Compile SDK Libraries"
cd ~/temp || exit #Coming out of SDL Folder

#Downloading and extracting the 3 addons
figlet Downloading and extracting the 3 addons | lolcat

sudo rm SDL2_image-2.0.5.tar.gz 
wget http://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.5.tar.gz || error "Failed to download SDL2_image-2.0.5.tar.gz"
sudo rm -r ~/temp/SDL2_image-2.0.5 #Removing extracted folder if extracted before
tar zxvf SDL2_image-2.0.5.tar.gz || error "Failed to extract SDL2_image-2.0.5.tar.gz"#Extracting addons

sudo rm SDL2_mixer-2.0.4.tar.gz 
wget http://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.tar.gz || error "Failed to download SDL2_mixer-2.0.4.tar.gz"
sudo rm -r SDL2_mixer-2.0.4 #Removing extracted folder if extracted before
tar zxvf SDL2_mixer-2.0.4.tar.gz || error "Failed to extract SDL2_mixer-2.0.4.tar.gz"#Extracting addons

sudo rm SDL2_ttf-2.0.15.tar.gz 
wget http://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.15.tar.gz || error "Failed to download SDL2_ttf-2.0.15.tar.gz "
sudo rm -r SDL2_ttf-2.0.15 #Removing extracted folder if extracted before
tar zxvf SDL2_ttf-2.0.15.tar.gz || error "Failed to extract SDL2_ttf-2.0.15.tar.gz "#Extracting addons



#Building the 3 addons
figlet Building the 3 addons | lolcat


cd SDL2_image-2.0.5 || exit
./autogen.sh || error "Failed to build SDL2_image-2.0.5 "
./configure --prefix=/usr || error "Failed to build SDL2_image-2.0.5"
make || error "Failed to build SDL2_image-2.0.5"
sudo make install || error "Failed to build SDL2_image-2.0.5 "
cd .. || exit

cd SDL2_mixer-2.0.4 || exit
./autogen.sh || error "Failed to build SDL2_mixer-2.0.4 "
./configure --prefix=/usr || error "Failed to build SDL2_mixer-2.0.4 "
make || error "Failed to build SDL2_mixer-2.0.4 "
sudo make install || error "Failed to build SDL2_mixer-2.0.4 "
cd .. || exit

cd SDL2_ttf-2.0.15 || exit
./autogen.sh || error "Failed to build SDL2_ttf-2.0.15"
./configure --prefix=/usr || error "Failed to build SDL2_ttf-2.0.15"
make || error "Failed to build SDL2_ttf-2.0.15"
sudo make install || error "Failed to build SDL2_ttf-2.0.15"
cd .. || exit


figlet Installing dhewm3 | lolcat

sudo rm -r ~/temp/dhewm3 #Removing repository if it is already clone
git clone https://github.com/dhewm/dhewm3 || error "Failed to clone dhewm3 from github" #Cloning dhewm3 repository
cd ~/temp/dhewm3/neo/ || exit


#currently in ~/temp/dhewm3/neo  

sudo rm -r ~/temp/dhewm3/neo/build
mkdir ~/temp/dhewm3/neo/build || error "Failed to create build folder"
cd ~/temp/dhewm3/neo/build || exit
cmake ..  || error "Failed to build dhewm3"
make -j4  || error "Failed to build dhewm3"


Yes_Downloading_torrent () {
  figlet Downloading Game Files | lolcat
  cd ~/RPIDoom3Installer || exit
  wget https://github.com/techcoder20/RPIDoom3Installer/releases/download/1.0.0/Doom3DemoGameFiles.zip || error "Failed to download game files"
  unzip Doom3DemoGameFiles.zip || error "Failed to extract game files"
  cd ~/temp/dhewm3/neo/build/ || exit
  cp base.so d3xp.so dhewm3 libidlib.a ~/RPIDoom3Installer/Doom3DemoGameFiles || error "Failed to copy necessary files to Doom3DemoGameFile Folder"
  cp ~/Doom3DemoGameFiles/Doom3Demo.desktop ~/Desktop || error ""
}

No_Downloading_torrent () {
  mkdir ~/Doom3GameFiles || error "Failed to create Doom3GameFiles Folder"
  figlet -w 90 Please place the game files in ~/Doom3GameFiles | lolcat 
  cd ~/temp/dhewm3/neo/build/ || exit
  cp base.so d3xp.so dhewm3 libidlib.a ~/Doom3GameFiles || error "Failed to copy necessary files to Doom3GameFile Folder"
}

while true; do
    read -p -r "Do you have the game files [Y/n]?" yn
    case $yn in
        [Yy]* ) No_Downloading_torrent; exit;;
        [Nn]* ) Yes_Downloading_torrent; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done





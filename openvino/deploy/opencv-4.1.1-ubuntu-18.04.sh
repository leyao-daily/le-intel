#!/bin/bash

echo "OpenCV installation"

#Specify OpenCV version
cvVersion="4.1.1"

# Clean build directories
rm -rf opencv/build
rm -rf opencv_contrib/build

# Create directory for installation
mkdir installation
mkdir installation/OpenCV-"$cvVersion"

# Save current working directory
cwd=$(pwd)

sudo apt -y update
sudo apt -y upgrade

#Generic tools
sudo apt install build-essential cmake pkg-config unzip yasm git checkinstall

#Image I/O libs
sudo apt install libjpeg-dev libpng-dev libtiff-dev libjasper-dev

#Video/Audio Libs - FFMPEG, GSTREAMER, x264 and so on.
sudo apt install libavcodec-dev libavformat-dev libswscale-dev libavresample-dev
sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt install libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev
sudo apt install libfaac-dev libmp3lame-dev libvorbis-dev

#OpenCore - Adaptive Multi Rate Narrow Band (AMRNB) and Wide Band (AMRWB) speech codec
sudo apt install libopencore-amrnb-dev libopencore-amrwb-dev

#Cameras programming interface libs
sudo apt-get install libdc1394-22 libdc1394-22-dev libxine2-dev libv4l-dev v4l-utils
cd /usr/include/linux
sudo ln -s -f ../libv4l1-videodev.h videodev.h
cd "$cwd" 

#GTK lib for the graphical user functionalites coming from OpenCV highghui module
sudo apt-get install libgtk-3-dev

#Python libraries for python2 and python3
sudo apt-get install python3-dev python3-pip
sudo -H pip3 install -U pip numpy
sudo apt install python3-tesresources

#Parallelism library C++ for CPU
sudo apt-get install libtbb-dev

#Optimization libraries for OpenCV
sudo apt-get install libatlas-base-dev gfortran

#Optional libraries:
udo apt-get install libprotobuf-dev protobuf-compiler
sudo apt-get install libgoogle-glog-dev libgflags-dev
sudo apt-get install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

#Python virtual env
cd $cwd
############ For Python 3 ############
# create virtual environment
python3 -m venv OpenCV-"$cvVersion"-py3
echo "# Virtual Environment Wrapper" >> ~/.bashrc
echo "alias workoncv-$cvVersion=\"source $cwd/OpenCV-$cvVersion-py3/bin/activate\"" >> ~/.bashrc
source "$cwd"/OpenCV-"$cvVersion"-py3/bin/activate

# now install python libraries within this virtual environment
pip install wheel numpy scipy matplotlib scikit-image scikit-learn ipython dlib

# quit virtual environment
deactivate

#Download the source and install
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout $cvVersion
cd ..
 
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout $cvVersion
cd ..

cd opencv
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D OPENCV_PYTHON3_INSTALL_PATH=$cwd/OpenCV-$cvVersion-py3/lib/python3.6/site-packages \
    -D BUILD_EXAMPLES=ON ..

#Make and install
make -j4
make install


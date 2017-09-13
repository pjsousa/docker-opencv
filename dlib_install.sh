#!/bin/bash

source /usr/local/bin/virtualenvwrapper.sh

mkvirtualenv cv -p python2

workon cv

#Build DLIB
wget http://dlib.net/files/dlib-19.4.tar.bz2
tar xvf dlib-19.4.tar.bz2
cd $HOME/dlib-19.4/
mkdir -p $HOME/build
cd $HOME/dlib-19.4/build
cmake ..
cmake --build . --config Release
make install
ldconfig
cd $HOME/dlib-19.4/
pkg-config --libs --cflags dlib-1
pip install dlib


FROM	ubuntu:latest

ENV HOME /root
ENV WORKON_HOME $HOME/.virtualenvs

RUN apt-get update
RUN apt-get upgrade

RUN apt-get install -y build-essential cmake pkg-config

RUN apt-get install -y libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev

RUN apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
RUN apt-get install -y libxvidcore-dev libx264-dev


RUN apt-get install -y libgtk-3-dev

RUN apt-get install -y libatlas-base-dev gfortran

RUN apt-get install -y python2.7-dev python3.5-dev

RUN apt-get install -y wget zip

WORKDIR $HOME
RUN wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.1.0.zip
RUN unzip opencv.zip

RUN wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.1.0.zip
RUN unzip opencv_contrib.zip

WORKDIR $HOME
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py


RUN pip install virtualenv virtualenvwrapper
RUN rm -rf ~/get-pip.py ~/.cache/pip

COPY bashrc1 /root/.bashrc
COPY build_opencv.sh $HOME/build_opencv.sh

WORKDIR $HOME/opencv-3.1.0/
RUN mkdir $HOME/opencv-3.1.0/build

RUN	/bin/bash $HOME/build_opencv.sh
RUN rm -rf $HOME/build_opencv.sh

# virtualenv and virtualenvwrapper VARs
# RUN mkvirtualenv cv -p python2

# COPY	bashrc2 /root/.bashrc

# RUN pip install numpy

# WORKDIR $HOME/opencv-3.1.0/
# RUN mkdir build
# WORKDIR $HOME/opencv-3.1.0/build
# RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
#     -D CMAKE_INSTALL_PREFIX=/usr/local \
#     -D INSTALL_PYTHON_EXAMPLES=ON \
#     -D INSTALL_C_EXAMPLES=OFF \
#     -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.1.0/modules \
#     -D PYTHON_EXECUTABLE=~/.virtualenvs/cv/bin/python \
#     -D BUILD_EXAMPLES=ON ..

# RUN make -j4

# RUN make clean
# RUN make

# RUN make install
# RUN ldconfig

# WORKDIR $HOME/.virtualenvs/cv/lib/python2.7/site-packages/
# RUN ln -s /usr/local/lib/python2.7/site-packages/cv2.so cv2.so


WORKDIR $HOME

COPY	bashrc2 /root/.bashrc

RUN rm -rf opencv-3.1.0 opencv_contrib-3.1.0 opencv.zip opencv_contrib.zip


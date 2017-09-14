FROM  ubuntu:latest

ENV HOME /root
ENV WORKON_HOME $HOME/.virtualenvs

RUN apt-get -y update
RUN apt-get -y upgrade


#Prerequisites
RUN apt-get install -y build-essential cmake pkg-config\
                     libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev\
                     libavcodec-dev libavformat-dev libswscale-dev libv4l-dev\
                     libxvidcore-dev libx264-dev\
                     libgtk-3-dev libx11-dev libboost-python-dev\
                     libatlas-base-dev gfortran\
                     python2.7-dev python3.5-dev\
                     wget zip


# Fetch OpenCV repos
WORKDIR $HOME
RUN wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.3.0.zip
RUN unzip opencv.zip
RUN wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.3.0.zip
RUN unzip opencv_contrib.zip

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install virtualenv virtualenvwrapper


COPY bashrc1 /root/.bashrc
COPY build_opencv.sh $HOME/build_opencv.sh
COPY pip_install.sh $HOME/pip_install.sh
RUN mkdir $HOME/opencv-3.3.0/build


#Build OpenCv, Install pip
RUN /bin/bash $HOME/build_opencv.sh
RUN /bin/bash $HOME/pip_install.sh

WORKDIR $HOME

COPY  bashrc2 /root/.bashrc


#Build DLIB
COPY dlib_install.sh $HOME/dlib_install.sh
RUN /bin/bash $HOME/dlib_install.sh

WORKDIR $HOME

RUN rm -rf $HOME/get-pip.py $HOME/.cache/pip\
           $HOME/opencv-3.3.0 $HOME/opencv_contrib-3.3.0\
           $HOME/opencv.zip $HOME/opencv_contrib.zip\
           $HOME/dlib-19.4\
           $HOME/build_opencv.sh $HOME/pip_install.sh $HOME/dlib_install.sh

EXPOSE 8888

#Load jupyter config and create ssl certificates
RUN mkdir -p $HOME/jupyterdata
RUN mkdir -p $HOME/.jupyter
COPY jupyter_notebook_config.py $HOME/.jupyter/jupyter_notebook_config.py

RUN openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
    -keyout ~/.jupyter/selfcert.key  -out ~/.jupyter/selfcert.cert

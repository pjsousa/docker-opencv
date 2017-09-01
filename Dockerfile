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

RUN mkdir $HOME/opencv-3.1.0/build

RUN	/bin/bash $HOME/build_opencv.sh
RUN	/bin/bash $HOME/pip_install.sh

WORKDIR $HOME

COPY	bashrc2 /root/.bashrc

RUN rm -rf $HOME/get-pip.py $HOME/.cache/pip
RUN rm -rf opencv-3.1.0 opencv_contrib-3.1.0 opencv.zip opencv_contrib.zip
RUN rm -rf $HOME/build_opencv.sh
RUN rm -rf $HOME/pip_install.sh

EXPOSE 8888

#Load jupyter config and create ssl certificates
RUN mkdir -p $HOME/jupyterdata
RUN mkdir -p $HOME/.jupyter
COPY jupyter_notebook_config.py $HOME/.jupyter/jupyter_notebook_config.py

RUN openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
    -keyout ~/.jupyter/selfcert.key  -out ~/.jupyter/selfcert.cert

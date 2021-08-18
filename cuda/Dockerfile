# aerospace software
# author: Michael Shamberger

# build pastix
FROM intel/oneapi-hpckit:latest
RUN apt-get update
RUN apt-get install -y wget git flex bison libz-dev software-properties-common
RUN apt-get install -y freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev
WORKDIR /tmp

#RUN apt-get install -y nvidia-cuda-toolkit
RUN add-apt-repository ppa:graphics-drivers/ppa
RUN apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" | tee /etc/apt/sources.list.d/cuda.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-overwrite" install cuda-11-4 cuda-drivers


# add command
WORKDIR /

# aerospace software
# author: Michael Shamberger

FROM continuumio/anaconda3
EXPOSE 8888

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y wget git unzip vim libglu1-mesa-dev freeglut3-dev mesa-common-dev libxmu-dev software-properties-common gnuplot gmsh tetgen imagemagick
WORKDIR /root
# cgx
RUN wget http://www.dhondt.de/cgx_2.17.1.bz2 && \
    bzip2 -d cgx_2.17.1.bz2 && \
    mv cgx_2.17.1 /usr/local/bin/cgx && \
    chmod 755 /usr/local/bin/cgx
# examples for testing
RUN wget https://github.com/opme/CalculiX-Examples/archive/b686c9b45fa2634bd0023222d88790ab7795ed86.zip && \
    unzip b686c9b45fa2634bd0023222d88790ab7795ed86.zip && \
    rm b686c9b45fa2634bd0023222d88790ab7795ed86.zip
COPY cgx /root/.cgx

# install gmsh
#RUN wget http://gmsh.info/bin/Linux/gmsh-4.8.4-Linux64.tgz && \
#    tar zxvf gmsh-4.8.4-Linux64.tgz &&
#    cp gmsh-4.8.4-Linux64/bin/gmsh /usr/local/bin

# install ngsolve

# get the ccx binaries from the other images
COPY --from=overpoweredmechanisms/calculix_gnu /usr/local/bin/ccx /usr/local/bin/ccx

ENV PATH=/root/CalculiX-Examples-master/Scripts:$PATH
CMD ["jupyter", "lab", "--ip='0.0.0.0'", "--port=8888", "--no-browser", "--allow-root"]

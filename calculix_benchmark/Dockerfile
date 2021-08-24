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
RUN wget https://github.com/opme/CalculiX-Examples/archive/faab994d45c10d21da5b3b0667efdeeb269992e9.zip && \
    unzip faab994d45c10d21da5b3b0667efdeeb269992e9.zip && \
    rm faab994d45c10d21da5b3b0667efdeeb269992e9.zip && \
    mv CalculiX-Examples-faab994d45c10d21da5b3b0667efdeeb269992e9 CalculiX-Examples
COPY cgx /root/.cgx

# install cgxCadTools
RUN wget http://www.dhondt.de/cgxCadTools.tar.bz2 && \
    bzip2 -d cgxCadTools.tar.bz2 && \
    tar xvf cgxCadTools.tar && \
    cp cgxCadTools/bin/cad2fbd /usr/local/bin && \
    cp cgxCadTools/bin/fbd2cad /usr/local/bin
# cgxCadTools needs opencascade 7.1.0 iibs
#RUN wget https://dev.opencascade.org/system/files/occt/OCC_7.1.0_release/opencascade-7.1.0.tgz && \
#    tar zxvf opencascade-7.1.0.tgz

# allow ghostscript in imagemagick
COPY imagemagick/policy.xml /etc/ImageMagick-6/policy.xml

# install gmsh
#RUN wget http://gmsh.info/bin/Linux/gmsh-4.8.4-Linux64.tgz && \
#    tar zxvf gmsh-4.8.4-Linux64.tgz &&
#    cp gmsh-4.8.4-Linux64/bin/gmsh /usr/local/bin

# install ngsolve

# get the ccx binaries from the other images
COPY --from=overpoweredmechanisms/calculix_gnu /usr/local/bin/ccx /usr/local/bin/ccx

ENV PATH=/root/CalculiX-Examples-master/Scripts:$PATH
ENV OMP_NUM_THREADS=6
CMD ["jupyter", "lab", "--ip='0.0.0.0'", "--port=8888", "--no-browser", "--allow-root"]

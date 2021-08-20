# calculix_docker

This project contains the following Calculix 2.17 builds:

- GNU compilers - compiles not tested

- GNU compilers with OpenBlas and PasTiX gpu enabled - compiles not tested

- Intel compilers - compiles with basic testing

- Intel compilers with MKL and PasTiX gpu enabled - compiles


Running using GPU
------------------

'''
# Add the package repositories
$ distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
$ curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
$ curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

$ sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
$ sudo systemctl restart docker
'''

Running the docker with GPU support

'''
docker run --name my_all_gpu_container --gpus all -t nvidia/cuda
'''

Please note, the flag --gpus all is used to assign all available gpus to the docker container.

To assign specific gpu to the docker container (in case of multiple GPUs available in your machine)

docker run --name my_first_gpu_container --gpus device=0 nvidia/cuda

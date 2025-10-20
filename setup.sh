#!/bin/bash
set -e

# Atualiza pacotes e instala git
sudo apt-get update -y
sudo apt-get install -y git

# Clona o repositório
cd /users/paulina
echo "update"
sudo -S apt-get update -y
sudo apt install build-essential -y
echo "Instalando automake"
sudo apt-get install autoconf automake -y
echo "Clonando repositorio CHARM"
git clone https://github.com/PaulinaEster/charm.git

# Entra na pasta do repositório
cd /users/paulina/charm 

echo "Iniciando build do charm"
# build charm++ com maleabilidade
./build charm++ netlrts-linux-x86_64 --enable-shrinkexpand

echo "Compilando arquivos para executar"
cd ./netlrts-linux-x86_64/examples/charm++/shrink_expand && make client
cd ./jacobi2d-iter && make
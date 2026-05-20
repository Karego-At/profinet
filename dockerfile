FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git cmake build-essential libsnmp-dev iproute2 iputils-ping tshark util-linux  && rm -rf /var/lib/apt/lists/*
    

COPY ./ /p-net

WORKDIR /p-net

RUN cmake -B build -S . && cmake --build build

RUN cd ./build && touch button1.txt button2.txt

WORKDIR /p-net/build

CMD ["taskset", "-c", "11", "./pn_dev", "-vvvv", "-i", "eth0", "-b", "button1.txt", "-d", "button2.txt"]


# WORKDIR /p-net/build






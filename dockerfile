FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git cmake build-essential libsnmp-dev iproute2 iputils-ping tshark util-linux \
    wget gpg \
    && rm -rf /var/lib/apt/lists/*

# Установить актуальный CMake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | gpg --dearmor -o /usr/share/keyrings/kitware-archive-keyring.gpg \
    && echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' > /etc/apt/sources.list.d/kitware.list \
    && apt-get update && apt-get install -y cmake \
    && rm -rf /var/lib/apt/lists/*

COPY ./ /p-net

WORKDIR /p-net

RUN cmake -B build -S . && cmake --build build

RUN cd ./build && touch button1.txt button2.txt

WORKDIR /p-net/build

CMD ["taskset", "-c", "11", "./pn_dev", "-vvvv", "-i", "eth0", "-b", "button1.txt", "-d", "button2.txt"]


# WORKDIR /p-net/build






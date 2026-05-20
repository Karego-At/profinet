FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git curl build-essential libsnmp-dev iproute2 iputils-ping tshark util-linux 
    # wget gpg \
    # && rm -rf /var/lib/apt/lists/*

WORKDIR /root
RUN mkdir temp
WORKDIR /root/temp
RUN curl -OL https://github.com/Kitware/CMake/releases/download/v3.27.4/cmake-3.27.4.tar.gz
RUN tar -xzvf cmake-3.27.4.tar.gz

WORKDIR /root/temp/cmake-3.27.4
RUN ./bootstrap -- -DCMAKE_BUILD_TYPE:STRING=Release
RUN make -j4
RUN make install

WORKDIR /root
RUN rm -rf temp

# CMD ["cmake", "--version"]

COPY ./ /p-net

WORKDIR /p-net

RUN cmake -B build -S . && cmake --build build

RUN cd ./build && touch button1.txt button2.txt

WORKDIR /p-net/build

CMD ["taskset", "-c", "11", "./pn_dev", "-vvvv", "-i", "eth0", "-b", "button1.txt", "-d", "button2.txt"]








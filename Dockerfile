FROM ubuntu

RUN apt-get update
RUN apt-get install -y git cmake gettext libgd-dev libusb-1.0-0-de
RUN git clone https://git.familie-radermacher.ch/linux/ptouch-print.git
RUN cd ptouch-print && ./build.sh
RUN ptouch-print/build/ptouch-print --version
RUN cd ptouch-print && make -C build/ install

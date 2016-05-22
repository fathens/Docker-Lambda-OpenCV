FROM centos:7

RUN yum groupinstall -y "Development Tools" && yum install -y cmake bsdtar nasm

RUN set -x && mkdir -pv ~/tmp && cd ~/tmp \
  && curl https://nodejs.org/download/release/v4.3.2/node-v4.3.2.tar.gz | tar zxf - && cd node-* \
  && ./configure \
  && make install

RUN set -x && mkdir -pv ~/tmp && cd ~/tmp \
  && curl https://ffmpeg.org/releases/ffmpeg-3.0.2.tar.bz2 | tar -jxf - && cd ffmpeg-* \
  && ./configure --enable-shared --disable-static --disable-programs --disable-doc --prefix=/var/task \
  && make install

RUN set -x && mkdir -pv ~/tmp && cd ~/tmp \
  && curl -L https://github.com/Itseez/opencv/archive/2.4.13.zip | bsdtar -xf- && cd opencv-* \
  && mkdir build && cd build \
  && PKG_CONFIG_PATH=/var/task/lib/pkgconfig cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/var/task ../ \
  && LD_LIBRARY_PATH=/var/task/lib make install

RUN rm -rf ~/tmp \
  && echo "Build Complete: Version 1.0.0"

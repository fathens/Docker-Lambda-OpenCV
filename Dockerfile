FROM centos:7

RUN yum groupinstall -y "Development Tools" && yum install -y cmake bsdtar nasm

RUN set -x \
  && curl -sL https://rpm.nodesource.com/setup_4.x | bash - \
  && yum install -y nodejs

RUN set -x && mkdir -pv ~/tmp && cd ~/tmp \
  && curl https://ffmpeg.org/releases/ffmpeg-3.0.2.tar.bz2 | tar -jxf - && cd ffmpeg-* \
  && ./configure --enable-shared --disable-static --disable-programs --disable-doc --prefix=/var/task \
  && make install

RUN set -x && mkdir -pv ~/tmp && cd ~/tmp \
  && curl -L https://github.com/Itseez/opencv/archive/3.1.0.zip | bsdtar -xf- && cd opencv-* \
  && mkdir build && cd build \
  && curl -L https://github.com/Itseez/opencv_contrib/archive/3.1.0.tar.gz | tar -zxf - && CONTRIB=$(ls -d opencv_contrib-*/modules) \
  && export PKG_CONFIG_PATH=/var/task/lib/pkgconfig \
  && export LD_LIBRARY_PATH=/var/task/lib \
  && cmake -D OPENCV_EXTRA_MODULES_PATH=$CONTRIB -D BUILD_opencv_world=ON -D BUILD_opencv_contrib_world=ON -D WITH_OPENCL=OFF -D WITH_IPP=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/var/task ../ \
  && make install

RUN rm -rf ~/tmp \
  && echo "Build Complete: Version 1.1.0"

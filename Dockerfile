FROM sawatani/ami-lambda_node43

RUN set -x

RUN mkdir -pv ~/tmp && cd ~/tmp \
  && curl -L https://ffmpeg.org/releases/ffmpeg-3.0.2.tar.bz2 | tar -jxf - && cd ffmpeg-* \
  && ./configure --enable-shared --disable-static --disable-programs --disable-doc --prefix=/var/task \
  && make install

RUN mkdir -pv ~/tmp && cd ~/tmp \
  && curl -#L https://github.com/Itseez/opencv/archive/2.4.13.zip | bsdtar -xf- && cd opencv-* \
  && mkdir build && cd build \
  && PKG_CONFIG_PATH=/var/task/lib/pkgconfig cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/var/task ../ \
  && LD_LIBRARY_PATH=/var/task/lib make install \
  && cd /usr/local/opencv/share/OpenCV/3rdparty/lib && for file in liblib*; do sudo ln -s $file ${file##lib}; done && ls -la

RUN rm -rf ~/tmp

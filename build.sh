#!/bin/bash
# https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

sudo apt-get -y install autoconf automake build-essential pkg-config libtool yasm texi2html \
  libsdl1.2-dev libva-dev libvdpau-dev libx11-dev libxext-dev libxfixes-dev zlib1g-dev

cd $FFMPEG_SRC_DIR
wget http://ffmpeg.org/releases/ffmpeg-$FFMPEG_VERSION.tar.bz2
tar xjvf ffmpeg-$FFMPEG_VERSION.tar.bz2
patch -u ffmpeg*/libavdevice/x11grab.c < $FFMPEG_BUILD_DIR/1738.patch

cd ffmpeg*
PKG_CONFIG_PATH="$FFMPEG_BUILD_DIR/lib/pkgconfig" ./configure \
  --prefix="$FFMPEG_BUILD_DIR" \
  --extra-cflags="-I$FFMPEG_BUILD_DIR/include" \
  --extra-ldflags="-L$FFMPEG_BUILD_DIR/lib" \
  --bindir="$FFMPEG_BIN_DIR" \
  --enable-gpl \
  --enable-x11grab
make
make install
make distclean
hash -r

cd $FFMPEG_BIN_DIR
tar cfvj $FFMPEG_TARBALL ffmpeg ffplay ffprobe ffserver

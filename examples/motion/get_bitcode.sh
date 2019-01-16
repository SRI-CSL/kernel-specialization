cd sources

cd ffmpeg-3.4.4
cc=${MUSLLVM}/obj/musl-clang ./configure
make 
cd ..

cd libwebp-0.6.1			# does not work with musl-clang
./autogen.sh
CC=gclang LD=/usr/bin/ld ./configure --enable-libwebpmux
make
cd ..

cd libmicrohttpd-0.9.59
CC=${MUSLLVM}/obj/musl-clang LD=/usr/bin/ld ./configure
make
cd ..

cd libjpeg-turbo-1.5.2
autoreconf
CC=${MUSLLVM}/obj/musl-clang LD=/usr/bin/ld ./configure
make
cd ..

cd bzip2-1.0.6
sed -i "/CC=gcc/d" Makefile
CC=${MUSLLVM}/obj/musl-clang make 
cd ..

cd ..
python extract_bitcode_with_obj.py extract_config_libraries built_libraries/
rm -rf wllvm_*

cp musl-clang-motion $MUSLLVM/obj/.
cd sources/motion-4.0
autoreconf -fiv
CC=${MUSLLVM}/obj/musl-clang-motion ./configure
sed -i "/LIBS         =/d" Makefile
LIBS="../../built_libraries/av_bcs/*  ../../built_libraries/av_objs/*  ../../built_libraries/bz2_bcs/* ../../built_libraries/jpeg_bcs/*  ../../built_libraries/jpeg_objs/*  ../../built_libraries/microhttpd_bcs/* ../../built_libraries/webp_bcs/*" make
get-bc -b motion
cp motion.bc ../..
cd ../..
get-bc -b $MUSLLVM/lib/libc.a
cp $MUSLLVM/lib/libc.a.bc .
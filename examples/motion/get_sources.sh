mkdir sources
cd sources
apt-get source motion
cd motion-4.0
sed -i -e "s/MD5Init/MD5Init_motion/g" $(grep -Ril "MD5Init")
sed -i -e "s/MD5Update/MD5Update_motion/g" $(grep -Ril "MD5Update")
sed -i -e "s/MD5Final/MD5Final_motion/g" $(grep -Ril "MD5Final")
LNO=$(awk '/void motion_log/{ print NR; exit }' logger.c) 
LNO=$(($LNO + 2))
sed -i $LNO"ireturn;" logger.c
# LIBS         = ~/motion-project/motion/av_bcs/*  ~/motion-project/motion/av_objs/*  ~/motion-project/motion/bzip2_bcs/* ~/motion-project/motion/jpeg_bcs/*  ~/motion-project/motion/jpeg_objs/*  ~/motion-project/motion/microhttpd_bcs/* ~/motion-project/motion/webp_bcs/*   
cd ..

apt-get source libavformat-dev
apt-get source libwebp-dev
apt-get source libmicrohttpd-dev
apt-get source libjpeg-turbo
apt-get source libbz2-dev

rm *.xz *.gz *.asc *.dsc *.bz2
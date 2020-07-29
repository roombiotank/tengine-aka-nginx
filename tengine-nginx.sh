#!/bin/bash
#
# Create By HASAN 
# Install tengine A.K.A Nginx
#
# SEBELUM MULAIN SIAPIN BAHANYA DULU CROOOOTT....
#==============================================================INSTALL JEROAN DULU YAAA=================================================================================
yum -y update
yum -y install gcc gcc-c++ bzip2 perl curl curl-devel expat-devel gettext-devel libxml2 libxml2-devel libjpeg-devel libpng-devel freetype-devel libmcrypt-devel autoconf

# Install PRCE
cd /usr/local/src && \
wget https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.gz && \
tar xvzf pcre-8.42.tar.gz && \
cd pcre-8.42 && \
make && \
make install && \
cd .. && \
rm -rf pcre-8.42.tar.gz

#INSTALL ZLIB
cd /usr/local/src && \
wget https://www.zlib.net/fossils/zlib-1.2.8.tar.gz && \
tar xvzf zlib-1.2.8.tar.gz && \
make && \
make install && \
cd .. && \
rm -rf zlib-1.2.8.tar.gz

#INSTALL JEMALOC
cd /usr/local/src && \
wget https://distfiles.macports.org/jemalloc/jemalloc-5.2.1.tar.bz2 && \
tar xvf jemalloc-5.2.1.tar.bz2 && \
make && \
make install && \
cd .. && \
rm -rf jemalloc-5.2.1.tar.bz2

#INSTALL OPEN-SSL
cd /usr/local/src && \
wget http://www.openssl.org/source/openssl-1.0.1h.tar.gz && \
tar xzvf openssl-1.0.1h.tar.gz && \
cd openssl-1.0.1h && \
./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl --libdir=lib shared zlib-dynamic -Wl,-R,'$(LIBRPATH)' -Wl,--enable-new-dtags
make && \
make install && \
cd .. && \
cp /etc/pki/tls/cert.pem /usr/local/openssl/cert.pem
rm -rf openssl-1.0.1h.tar.gz

#Nah Sekarang baru Install Jantungnya TENGIX
cd /usr/local/src && \
wget https://tengine.taobao.org/download/tengine-2.3.2.tar.gz && \
tar xvzf tengine-2.3.2.tar.gz && \
cd tengine-2.3.2 && \
./configure --prefix=/usr/local/nginx \
--user=www \
--group=www \
--with-pcre=/usr/local/src/pcre-8.42 \
--with-openssl=/usr/local/src/openssl-1.0.1h \
--with-jemalloc=/usr/local/src/jemalloc-5.2.1 \
--with-zlib=/usr/local/src/zlib-1.2.8 \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-http_stub_status_module
make && \
make install && \
cd .. && \
rm -rf tengine-2.3.2.tar.gz

#CREATE SERVICE SYSTEMD
cd /lib/systemd/system && \

touch nginx.service && \

echo $'i
[Unit]
Description=The nginx HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target \E:x\n' | vi tenginx.service


#START TENGINX
chmod +x tenginx.service
#Start nginx service 
systemctl start nginx.service
#Set boot from the start
systemctl enable nginx.service
#cek status
systemctl status nginx.service

#JIKA ADA ERROR [emerg] getpwnam("www") failed Jalankan perintah dibawah restart kembali servicenya ..
# /usr/sbin/groupadd  -f  www
# /usr/sbin/useradd  -g www www

#=====================================================================SELAMAT MENCOBA===================================================================================



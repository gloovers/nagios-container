FROM centos:7
LABEL maintainer="Andrei Andryieuski"
WORKDIR /tmp
RUN yum update
RUN yum install httpd mariadb-server php php-mysql gcc glibc glibc-common wget gd gd-devel perl postfix make gettext automake autoconf openssl-devel net-snmp net-snmp-utils epel-release perl-Net-SNMP
RUN wget -q https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.2.tar.gz -O nagioscore.tar.gz && \
    tar xzf nagioscore.tar.gz && \
    cd /tmp/nagioscore-nagios-4.4.2 && \
    ./configure && \
    make all && \
    make install-groups-users && \
    usermod -a -G nagios apache && \
    make install && \
    make install-daemoninit && \
    make install-config && \
    make install-commandmode && \
    make install-webconf
RUN htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
RUN cd /tmp && \
    wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz && \
    tar zxf nagios-plugins.tar.gz && \
    cd /tmp/nagios-plugins-release-2.2.1/ && \
    ./tools/setup && \
    ./configure && \
    make && \
    make install 
# ADD/COPY index.html /var/www/html/
EXPOSE 80
ENTRYPOINT ["httpd"]
CMD ["-DFOREGROUND"] 


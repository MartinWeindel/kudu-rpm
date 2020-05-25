FROM mweindel/apache-kudu:1.12.0

LABEL maintainer="martin.weindel@gmail.com"

ENV KUDU_VERSION 1.12.0

RUN yum -y install epel-release && \
    yum -y install python-sqlobject && \
    yum -y install https://github.com/genereese/togo/releases/download/v2.4r1/togo-2.4-1.noarch.rpm

ENV RPM_NAME kudu

RUN togo configure -n "Martin Weindel" -e "martin.weindel@gmail.com" && \
    cd /tmp && \
    togo project create ${RPM_NAME} && \
    cd ${RPM_NAME} && \
    mkdir -p root/usr/lib/kudu/sbin && \
    mkdir -p root/usr/lib/kudu/bin && \
    mkdir -p root/usr/share/doc/kudu-${KUDU_VERSION} && \
    mkdir -p root/usr/sbin && \
    mkdir -p root/usr/bin && \
    mkdir -p root/etc/kudu/conf.dist/ && \
    mkdir -p root/usr/lib/systemd/system/

RUN cd /tmp/${RPM_NAME} && \
    cp -a /opt/kudu/kudu root/usr/lib/kudu/bin && \
    cp -a /opt/kudu/kudu-master root/usr/lib/kudu/sbin && \
    cp -a /opt/kudu/kudu-tserver root/usr/lib/kudu/sbin && \
    cp -aR /opt/kudu/www root/usr/lib/kudu


ADD doc/* /tmp/${RPM_NAME}/root/usr/share/doc/kudu-${KUDU_VERSION}/

ADD sbin/* /tmp/${RPM_NAME}/root/usr/sbin/

ADD bin/* /tmp/${RPM_NAME}/root/usr/bin/

ADD system/* /tmp/${RPM_NAME}/root/usr/lib/systemd/system/

ADD etc/kudu/conf.dist/* /tmp/${RPM_NAME}/root/etc/kudu/conf.dist/

RUN cd /tmp/${RPM_NAME} && \
    togo file exclude root/usr/lib && \
    togo file exclude root/usr/lib/systemd/system && \
    togo file exclude root/usr/sbin && \
    togo file exclude root/usr/bin && \
    togo file exclude root/usr/share/doc && \
    togo file exclude root/etc/kudu

ADD spec/* /tmp/${RPM_NAME}/spec/

RUN cd /tmp/${RPM_NAME} && \
    togo build package    



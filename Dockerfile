FROM amazonlinux:2023

ADD . /usr/src
WORKDIR /usr/src

RUN yum groupinstall "Development Tools" -y
RUN yum install cmake3 -y
RUN yum install iptables -y
RUN cmake3 . && make
RUN yum groupremove "Development Tools" -y
RUN yum clean all
RUN rm -rf /var/cache/yum

EXPOSE 8008

CMD ./gwlbtun -c example-scripts/create-passthrough.sh -p 8008
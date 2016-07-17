FROM centos
MAINTAINER Renat Bekbolatov <renatbek@gmail.com>

RUN mkdir /huyaks
WORKDIR /huyaks
RUN curl -O https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz

RUN yum update -y
RUN yum-builddep -y python
RUN yum install -y make
RUN tar xf Python-3.5.2.tgz
WORKDIR /huyaks/Python-3.5.2
RUN ./configure
RUN make && make install

RUN rm /usr/bin/python
RUN ln -s /usr/local/bin/python3.5 /usr/bin/python
RUN ln -s /usr/local/bin/pip3.5 /usr/bin/pip

WORKDIR /huyaks
RUN rm -rf Python-3.5.2 Python-3.5.2.tgz

RUN pip install boto
RUN pip install requests
RUN pip install pyhocon

# READY
ADD upload_logs.py /huyaks


# Run the command on container startup
CMD ["/usr/bin/python", "-u", "upload_logs.py"]


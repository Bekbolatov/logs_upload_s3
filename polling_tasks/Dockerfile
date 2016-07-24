# will be building renatbek/logs:test
FROM centos:7
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
ADD scheduled_runner.py /huyaks/
ADD services /huyaks/services

ADD entrypoint.sh /huyaks/
RUN chmod +x /huyaks/entrypoint.sh

ADD conf /huyaks/conf

WORKDIR /huyaks

ENTRYPOINT ["/huyaks/entrypoint.sh"]

CMD ["/usr/bin/python",  "-u", "scheduled_runner.py"]

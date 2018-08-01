FROM debian
MAINTAINER Rafal Szkup <rafal@maracje.pl>

COPY run.sh /run.sh

RUN chmod +x /run.sh && \
apt-get update && apt-get -y install whois && \
rm -rf -- /var/lib/apt/* /var/log/*

VOLUME ["/source", "/destination"]

CMD /run.sh

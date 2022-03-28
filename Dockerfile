# Notice: Disable conntrack.

FROM --platform=linux/arm64/v8 ubuntu:18.04

ENV CONSUL_TEMPLATE_VERSION "0.28.0"
ENV CONSUL_VERSION          "1.11.4"


# Install chaperone process manager
RUN apt-get update
RUN apt-get install -y nginx
RUN apt-get update && apt-get -q -y install lsof
RUN apt-get install net-tools
RUN apt-get install psmisc
RUN apt-get -y install curl
RUN apt-get -y install wget
RUN apt-get -y install gpg


# Install consul-template + consul agent (binary)

# Modified from https://github.com/hashicorp/docker-consul/blob/master/0.X/Dockerfile
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      unzip wget \
    \
 && gpg --keyserver pgp.mit.edu --recv-keys C874011F0AB405110D02105534365D9472D7468F\
    \
    # consul-template
 && wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
 && wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS \
 && wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS.sig \
    \
 && gpg --batch --verify consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS.sig consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS \
 && grep consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS | sha256sum -c \
 && unzip -d /bin consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
 && rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
       consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS \
       consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS.sig \
    \
    # consul
 && wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip \
 && wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS \
 && wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig \
    \
 && gpg --batch --verify consul_${CONSUL_VERSION}_SHA256SUMS.sig consul_${CONSUL_VERSION}_SHA256SUMS \
 && grep consul_${CONSUL_VERSION}_linux_amd64.zip consul_${CONSUL_VERSION}_SHA256SUMS | sha256sum -c \
 && unzip -d /bin consul_${CONSUL_VERSION}_linux_amd64.zip \
 && rm consul_${CONSUL_VERSION}_linux_amd64.zip \
       consul_${CONSUL_VERSION}_SHA256SUMS \
       consul_${CONSUL_VERSION}_SHA256SUMS.sig \
    \
    # clean up
 && cd /tmp \
 && rm -rf /tmp/build \
 && rm -rf /root/.gnupg \
 && apt-get autoremove -y --purge \
      unzip wget \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*



RUN     rm /etc/nginx/sites-enabled/default
VOLUME  templates
COPY ./template /templates
COPY ./html /var/www/html




ENV CONSUL_URL http://172.17.0.1:8500

EXPOSE 443 80





# our container will expose port 80, where Nginx will be listening for new connections
# nginx listen ports



# Make daemon service dir for nginx if it doesn't exist, and empty service directory for nginx if it already contains a daemon file
RUN     mkdir -p /etc/service/nginx && rm -rf /etc/service/nginx/*





ADD     start.sh /bin/start.sh
ENTRYPOINT ["/bin/start.sh"]




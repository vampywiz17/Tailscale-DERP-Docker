FROM alpine:latest

LABEL org.opencontainers.image.source https://github.com/tijjjy/Tailscale-DERP-Docker

#Tailscale Version
ENV TSVersion 1.38.2

#Install Tailscale and requirements
RUN apk add curl iptables

#Install GO and Tailscale DERPER
RUN apk add go --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
RUN go install tailscale.com/cmd/derper@v${TSVersion}

#Install Tailscale and Tailscaled
RUN curl https://pkgs.tailscale.com/stable/tailscale_${TSVersion}_amd64.tgz -o /tmp/tailscale_${TSVersion}_amd64.tgz
RUN cd /tmp && tar -xvf /tmp/tailscale_${TSVersion}_amd64.tgz
RUN cp /tmp/tailscale_${TSVersion}_amd64/tailscaled /usr/sbin/tailscaled
RUN cp /tmp/tailscale_${TSVersion}_amd64/tailscale /usr/bin/tailscale

#Copy init script
COPY init.sh /init.sh
RUN chmod +x /init.sh

#Derper Web Ports
EXPOSE 80
EXPOSE 443/tcp
#STUN
EXPOSE 3478/udp

ENTRYPOINT /init.sh

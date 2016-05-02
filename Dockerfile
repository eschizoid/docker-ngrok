FROM armv7/armhf-ubuntu
MAINTAINER Werner Beroux <werner@beroux.com>

RUN apt-get update \
 &&  apt-get install -y --no-install-recommends unzip

# Install ngrok (latest official stable from https://ngrok.com/download).
ADD https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip /ngrok.zip
RUN set -x \
 && unzip -o ngrok.zip -d /bin \
 && rm -f /ngrok.zip

# Add config script.
COPY ngrok.yml /home/ngrok/.ngrok2/
COPY entrypoint.sh /

# Create non-root user.
RUN set -x \
 && echo 'ngrok:x:6737:6737:Ngrok user:/home/ngrok:/bin/false' >> /etc/passwd \
 && echo 'ngrok:x:6737:' >> /etc/group \
 && chown ngrok:ngrok /home/ngrok \
 && chmod -R go=u,go-w /home/ngrok \
 && chmod go= /home/ngrok

USER ngrok

EXPOSE 4040

CMD ["/entrypoint.sh"]

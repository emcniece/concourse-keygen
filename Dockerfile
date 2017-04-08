FROM alpine:3.4

RUN  apk update \
  && apk add openssh-client

VOLUME /concourse-keys

COPY entry.sh /

ENTRYPOINT ["/entry.sh"]
FROM alpine:3.6
MAINTAINER Peyton Vaughn <pvaughn@6fusion.com>


WORKDIR  /home/load
COPY entrypoint.sh /app/entrypoint.sh

RUN apk --update add curl && \
    adduser -S load

USER load

CMD ["/app/entrypoint.sh"]


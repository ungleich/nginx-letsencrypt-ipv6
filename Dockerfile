FROM alpine
LABEL maintainer = "docker@ungleich.ch"

RUN apk add --no-cache nginx certbot sipcalc
RUN mkdir /run/nginx
COPY entrypoint.sh /

CMD [ "/entrypoint.sh" ]

FROM alpine:latest

RUN apk add --update curl bash && rm -rf /var/cache/apk/*

ADD script.sh /script.sh

ENTRYPOINT ["/script.sh"]

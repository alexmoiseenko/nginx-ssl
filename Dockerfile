FROM alpine

RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*

COPY --from=trajano/alpine-libfaketime  /faketime.so /lib/faketime.so

ENV LD_PRELOAD=/lib/faketime.so \
    DONT_FAKE_MONOTONIC=1

WORKDIR /app

COPY ./generate.sh /

RUN chmod +x /generate.sh

ENTRYPOINT ["sh", "/generate.sh"]

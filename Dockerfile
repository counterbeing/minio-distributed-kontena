FROM minio/minio

MAINTAINER Cory Logan <he@corylogan.com>

ENTRYPOINT []
CMD []

RUN apk add --update --no-cache tini bash jq curl
RUN apk add --update --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted bats

WORKDIR /
ADD . /

CMD '/sbin/tini -- /entrypoint.sh"'

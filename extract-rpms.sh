#!/bin/bash

docker build . -t kudu-rpm

KUDU_VERSION=1.11.1
RELEASE=1

KUDU_RPM=kudu-${KUDU_VERSION}-${RELEASE}.x86_64.rpm

IMG_ID=$(dd if=/dev/urandom bs=1k count=1 2> /dev/null | LC_CTYPE=C tr -cd "a-z0-9" | cut -c 1-22)
docker create --name ${IMG_ID} kudu-rpm
docker cp ${IMG_ID}:/tmp/kudu/rpms/${KUDU_RPM} ${KUDU_RPM}
docker rm ${IMG_ID}


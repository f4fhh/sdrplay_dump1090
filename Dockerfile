FROM debian:stretch-slim AS base

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
        dumb-init \
        librtlsdr-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

FROM base as builder

ENV MAJVERS 2.13
ENV MINVERS .1
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	    wget \
	    ca-certificates

WORKDIR /tmp/sdrlib
RUN wget https://www.sdrplay.com/software/SDRplay_RSP_API-Linux-${MAJVERS}${MINVERS}.run && \
        export ARCH=`arch` && \
        sh ./SDRplay_RSP_API-Linux-${MAJVERS}${MINVERS}.run --tar xvf && \
        cp ${ARCH}/libmirsdrapi-rsp.so.${MAJVERS} /usr/local/lib/. && \
        chmod 644 /usr/local/lib/libmirsdrapi-rsp.so.${MAJVERS} && \
        ln -s /usr/local/lib/libmirsdrapi-rsp.so.${MAJVERS} /usr/local/lib/libmirsdrapi-rsp.so.2 && \
        ln -s /usr/local/lib/libmirsdrapi-rsp.so.2 /usr/local/lib/libmirsdrapi-rsp.so && \
        cp mirsdrapi-rsp.h /usr/local/include/. && \
        chmod 644 /usr/local/include/mirsdrapi-rsp.h
WORKDIR /usr/local/lib/dump1090
RUN wget -O - https://www.sdrplay.com/software/dump1090_1.3.1.linux.tar.gz | tar xvfz - --strip 2

FROM base

COPY --from=builder /usr/local/bin/ /usr/local/bin/
# Workaround a docker bug with 2 consecutive COPY
RUN true
COPY --from=builder /usr/local/lib/ /usr/local/lib/
RUN ldconfig
WORKDIR /usr/local/lib/dump1090
CMD ["./dump1090", "--dev-sdrplay", "--mlat", "--quiet", "--net"]

# Web portal
EXPOSE 8080/tcp
# RAW output
EXPOSE 30002/tcp
# BS output
EXPOSE 30003/tcp
# BEAST output
EXPOSE 30005/tcp

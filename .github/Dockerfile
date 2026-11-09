FROM ubuntu:22.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       gnucobol python3 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY *.cob ./
RUN cobc -x -o /usr/local/bin/InCollege InCollege.cob InCollege-Core.cob

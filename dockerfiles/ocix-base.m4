FROM debian:10.3-slim

include(shared/debian.m4)

RUN aptitude -f --no-gui -q -y --without-recommends install \
              libtool-bin:amd64 \
              perl-base:amd64 \
              texinfo:amd64
 
include(shared/docker.m4)

include(shared/label.m4)

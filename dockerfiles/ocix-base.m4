FROM debian:10.3-slim

include(shared/debian.m4)

RUN aptitude -f --no-gui -q -y --without-recommends install \
              libtool-bin \
              perl-base \
              texinfo
 
include(shared/docker.m4)

include(shared/label.m4)

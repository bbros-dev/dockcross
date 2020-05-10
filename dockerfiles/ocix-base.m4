FROM debian:10.3-slim

include(shared/aptitude.m4)

include(shared/environment.m4)

include(shared/debian.m4)

include(shared/docker.m4)

include(shared/label.m4)

# Restore our default workdir (from "ocix-base" image).
WORKDIR /work

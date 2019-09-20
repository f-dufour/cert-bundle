# Introduction

This bundles the pipeline for creating and issung Blockcerts.

# Dockerfile

The bundle is a Docker image build from the Dockerfile.

## Build

To build the docker image:

```shell
~$ git clone https://gitlab.univ-lorraine.fr/dufour18/cert-bundle-docker.git cert-bundle
~$ cd cert-bundle/
~$ docker build -t cert-bundle:latest .
```

:warning: As it will  build the bitcoin software from source, it is recommended to allocate 2GB min. of ram to docker.

:warning: Building the image can take a little bit of time

## Image size

In order to reduce final image size:
-  `&&` operators have been prefered over `RUN` instructions.
- apt-get install --no-instal-recommends have been used right after installing the dependencies.
- A cleaning stage has been added at the end of the building process.
- In this case, Ubutu base image has been used over alpine for convenience. It is possible to consider using alpine to further reduce image size

Image size without compiling bitcoin or berkleydb: circa. 450MB

# Use

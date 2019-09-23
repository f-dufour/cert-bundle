# Introduction

This bundles the pipeline for creating and issung Blockcerts.

# Dockerfile

The bundle is a Docker image build from the Dockerfile.

## :rocket: Build

To build the docker image:

```shell
~$ git clone https://gitlab.univ-lorraine.fr/dufour18/cert-bundle-docker.git cert-bundle
~$ cd cert-bundle/
~$ docker build -t cert-bundle:latest .
```

:warning: As it will  build the bitcoin software from source, it is recommended to allocate min. 2GB min. of ram to docker.

:warning: Building the image can take a little bit of time

## Image size

In order to reduce final image size:
-  `&&` operators have been prefered over `RUN` instructions.
- apt-get install --no-instal-recommends *should not be used* or installing python dependencies for Blockcerts will not complete sucessfully.
- A cleaning stage has been added at the end of the building process.
- In this case, Ubutu base image has been used over alpine for convenience. It is possible to consider using alpine to further reduce image size

Image size without compiling bitcoin or Berkeleydb: circa. 450MB

# Tests
cd
To test building the image without compiling bitcoin core and Berkeleydb, one can use Dockerfile.test

```shell
~$ docker build -t cert-bundle:test -f Dockerfile.test .
```

# Versions

| Software    | Version   |
|-------------|-----------|
| Ubuntu      | 18.04     |
| Bitcoin     | 0.18.1    |
| Berkeley DB | 4.8.30.NC |
| Blockcerts  | v2        |

# Use

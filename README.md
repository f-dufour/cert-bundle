# Introduction

This bundles the pipeline for creating and issung Blockcerts. The bundle is a Docker image build from the Dockerfile. It can be used as a standalone linux machine in which all the Blockcerts components and dependencies are properly installed and configured or as a command line utility that can automatically perform all the issuing steps and output blockchain certificates to the specified directory.

# Build

To build the :whale: image, clone and cd ino the directory, then:

```shell
~$ docker build -t cert-bundle .
```

:warning: As it will  build bitcoin core and Berkeley DB from source, it is recommended to allocate min. 2GB of RAM to docker.

:warning: Building the image can take a little bit of time.

## Image size

- Image size without compiling bitcoin or Berkelydb: circa. 569MB.
- Image size with bitcoin and Berkleydb: circa. 3.76GB.

Limiting the final image size:
-  `&&` operators have been preferred over `RUN` instructions.
- apt-get install --no-instal-recommends *should not be used* or python dependencies for Blockcerts will not intall sucessfully.
- A cleaning stage has been added at the end of the building process.
- In this case, Ubutu base image has been used over alpine for convenience. It is possible to consider using alpine to further reduce image size

## Experiments

See the misc folder.

To test building the image without compiling bitcoin core and Berkeleydb, one can use Dockerfile.test

```shell
~$ cd misc
~$ docker build -t cert-bundle:slim -f Dockerfile.cert-bundle-slim .
```

# Usage

cert-bundle requires the bitcoin blockchain to be available. The blockchain is stored on an external hard drive, inside the `bitcoin` subfolder. This latter also contains the configuration file `bitcoin.conf`. For any use of cert-bundle, the blockchain has to be mouted inside the container, at the `/root/.bitcoin` location.

## Use manually

cert-bundle can be used as an interactive linux machine in which we can use Blockcerts manually. All dependencies and tools have been installed and configured during the building phase.

### Instantiate the docker image

Once the docker image is build, one can run it in interactive mode:

With the helper script:

```shell
~$ chmod +x launchImage.sh
~$ ./launchImage.sh
```

Or manually:

```shell
~$ docker run -it --rm -v c:/Users/dufour:/mnt/data -v e:/bitcoin:root/.bitcoin/ cert-bundle
```

Once the image is instantiated, we use the term "container".

### Inside the container

1. Verify that bitcoin is ready to go

```shell
~$ bitcoin-cli getbalance
```

Should be above ... satoshis

2. Create template

```shell
~$ create-certificate-template -c conf.ini
```

3. Instatiate template

```shell
~$ instantiate-certificate-template -c conf.ini
```

4. Issue certificates

```shell
~$ cert-issuer -c conf.ini
```

Blockchain certificates are located inside `blockchain_certificates`

## Automatic use

```shell
~$ docker run -v c:/Users/dufour18:/mnt/data -v e:/bitcoin:/root/.bitcoin/ cert-bundle
```

# Versions

| Software    | Version   |
|-------------|-----------|
| Ubuntu      | 18.04     |
| Bitcoin     | 0.18.1    |
| Berkeley DB | 4.8.30.NC |
| Blockcerts  | v2        |


# Links

- [cert-tools on Blockcerts project](https://github.com/blockchain-certificates/cert-tools)
- [cert-issuer on Blockcerts project](https://github.com/blockchain-certificates/cert-issuer)

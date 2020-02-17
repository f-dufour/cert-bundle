# Introduction

This bundles the pipeline for creating and issung Blockcerts. It can be used as a standalone linux machine in which all the Blockcerts components and dependencies are properly installed and pre-configured.

# Get the image

To get the image, you can pull it or build it yourself

## Pull the image

```
~$ docker pull florentdufour/cert-bundle:latest
```

## Build the image

To build the :whale: image, clone and cd ino the directory, then:

```shell
~$ git clone https://github.com/f-dufour/cert-bundle.git
~$ cd cert-bundle/
~$ docker build -t cert-bundle:latest .
```

:warning: As it will  build bitcoin core and Berkeley DB from source, it is recommended to allocate min. 2GB of RAM to docker.

:warning: Building the image can take a little bit of time.

## Image size

- Image size without compiling bitcoin or Berkelydb: circa. 569MB.
- Image size with bitcoin and Berkleydb: circa. 3.76GB.

# Usage

cert-bundle requires the bitcoin blockchain to be available. The blockchain (circa. 250 GB) can be stored on an external hard-drive. The hard-drive has to be mouted inside the container, at the `/root/.bitcoin` location. the file `bitcoin.conf` can be provided as well through the mounted drive.


## Instantiate the docker image

Once the docker image is build, one can run it in interactive mode. Edit `launchImage.sh.template` and rename it `launchImage.sh`

With the helper script:

```shell
~$ chmod +x launchImage.sh
~$ ./launchImage.sh
```

## Preconfiguration, inside the container

1. You can now launch the bitcoin core server:

```shell
~# bitcoind
```

It will start downloading the bitcoin chain as set in `bitcoin.conf`

2. Verify that bitcoin is ready to go

```shell
~# bitcoin-cli getbalance
```

You will need at least 133500 satoshis

3. Configure cert-issuer

- In `/cert-issuer/conf.ini`, add the public key obtained with `bitcoin-cli getnewaddress` in the first field.
- Add the associated private key in `/cert-issuer/private.key` with `bitcoin-cli dumpprivkey YOUR-PUBLIC-KEY-HERE`

## Create and issue certificates

1. Modify `/cert-tools/conf.ini` and `/cert-issuer/conf.ini` to suit your needs

2. Create template

```shell
~# create-certificate-template -c /cert-tools/conf.ini
```

3. Instatiate template

```shell
~# instantiate-certificate-template -c /cert-tools/conf.ini
```

4. Issue certificates

```shell
~# cert-issuer -c /cert-issuer/conf.ini
```

Blockchain certificates are located inside `/cert-issuer/data/blockchain_certificates`, CONGRATS !

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

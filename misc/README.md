# Contains miscellaneous files for tests and experiments.

## Dockerfile.bitcoin

* bitcoind server compiled from source

```shell
~$ docker build -t bitcoind:0.18.1 -f Dockerfile.bitcoin .
```

## Dockerfile.cert-bundle-slim

* Blockcerts bundle of cert-tool and cert-issuer without bitcoin

```shell
~$ docker build -t bitcoind:0.18.1 -f Dockerfile.cert-bundle-slim .
```

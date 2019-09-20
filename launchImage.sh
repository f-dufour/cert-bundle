#!/usr/bin/bash

pathBlockchainPhysical="e:/bitcoin"
pathBlcokchainDocker="/root/.bitcoin"
pathDataPhysical="c:/Users/dufour18"
pathDataDocker="/mnt/data"

docker run -it --rm \
	-v "$pathBlockhainPhysical:$pathBlockchainDocker" \
	-v "$pathDataPhysical:$pathDataDocker" \
	cert-bundle:latest

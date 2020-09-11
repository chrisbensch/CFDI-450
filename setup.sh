#!/bin/bash

echo "Preparing containers..."

docker pull chrisbensch/docker-manalyzer
docker pull chrisbensch/docker-plaso
docker pull chrisbensch/docker-volatility

echo "Complete"
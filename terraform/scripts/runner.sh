#!/bin/bash

mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/latest/download/actions-runner-linux-x64.tar.gz
tar xzf actions-runner-linux-x64.tar.gz
sudo yum install -y libicu
./config.sh --url https://github.com/nethu9/microservices-pipeline --token AVIVAXDLC6GQXRXXTYPT3CTIMAEV4
./run.sh
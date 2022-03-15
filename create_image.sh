#!/bin/bash
pushd docker || exit 1
docker build . -t openvidu/cloudformation-patcher
popd || exit 1

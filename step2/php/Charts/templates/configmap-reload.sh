#!/bin/bash
cd $(dirname $0)

kubectl apply -f configmap.yaml

export CONFIG_HASH=$(find . -name "configmap.yaml"|xargs md5sum | awk '{print $1}')

envsubst '${CONFIG_HASH}' < deployment.yaml \
    | kubectl apply -f -

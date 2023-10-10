#!/bin/bash

# Define the deployment function
deploy() {
    local ENDPOINT="https://zeebeops1.sandbox.fynarfin.io"
    local cmd

    # Deploy with Platform-TenantId: gorilla
    cmd="curl --insecure --location --request POST $ENDPOINT/zeebe/upload \
        --header 'Platform-TenantId: gorilla' \
        --form 'file=\"\$PWD/$1\"'"
    echo $cmd
    eval $cmd

    # If curl response is not 200, fail the script
    if [ $? -ne 0 ]; then
        echo "Deployment failed"
        exit 1
    fi

    # Deploy with Platform-TenantId: rhino
    cmd="curl --insecure --location --request POST $ENDPOINT/zeebe/upload \
        --header 'Platform-TenantId: rhino' \
        --form 'file=\"\$PWD/$1\"'"
    echo $cmd
    eval $cmd

    # If curl response is not 200, fail the script
    if [ $? -ne 0 ]; then
        echo "Deployment failed"
        exit 1
    fi
}

# Deploy BPMN Files
LOC="orchestration/feel/*.bpmn"
for f in $LOC; do
    deploy $f
done

LOC2="orchestration/feel/example/*.bpmn"
for f in $LOC2; do
    deploy $f
done

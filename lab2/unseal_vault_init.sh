#!/usr/bin/env bash

VAULT_KEY="${1}"
VAULT_TOKEN="${2}"

oc exec -it $(oc get pods -l app=vault -o jsonpath='{.items[0].metadata.name}') -- sh
    export VAULT_ADDR=http://127.0.0.1:8200
    vault status
    vault operator init -key-shares=1 -key-threshold=1

    ### Important: save the unseal key and the root token in a separate file
    ### for later reuse, then assign them to the following env variables
    export VAULT_KEY="${VAULT_KEY}"
    export VAULT_TOKEN="${VAULT_TOKEN}"

    vault operator unseal $VAULT_KEY
    vault secrets enable -path=secret kv
    vault write secret/foo password=bar
    vault read secret/foo
exit

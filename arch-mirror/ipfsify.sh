#! /usr/bin/env bash

set -e
set -x

echo "## Initializing IPFS Repository"
#export IPFS_PATH=$(pwd)/.ipfs

#echo "## Setting IPFS config"
#ipfs config Addresses.API "/ip4/127.0.0.1/tcp/7001"
#ipfs config Addresses.Gateway "/ip4/127.0.0.1/tcp/7002"
#ipfs config Addresses.Swarm --json '["/ip4/0.0.0.0/tcp/7000"]'
#ipfs config --json Experimental.ShardingEnabled true
#ipfs config --json Experimental.FilestoreEnabled true
#ipfs config --json Datastore.NoSync true

#echo "## Generate IPNS key"
#docker exec ipfs_daemon_1 ipfs key gen --type=rsa --size=2048 "arch-repository" || true

echo "Adding 'arch-repository/' to IPFS"

# TODO should be with --nocopy but bug in the way...
# ipfs add -r --raw-leaves --local --nocopy ./arch-repository | tee hash-list
docker exec ipfs_daemon_1 ipfs add --offline -r --raw-leaves /arch-repository | tee hash-list
HASH="$(tail -n1 hash-list | cut -d ' ' -f2)"

#echo "Final hash is $HASH, publishing on IPNS"
#docker exec ipfs_daemon_1 ipfs name publish --key="arch-repository" /ipfs/$HASH

# curl -X PUT -H "Content-Type: application/json" -H "X-Api-Key: $APIKEY" -d "{\"rrset_values\": [\"dnslink=/ipfs/$HASH\"]}" https://dns.api.gandi.net/api/v5/domains/$ZONE/records/$RECORD/TXT | jq .
curl -X PUT "https://api.cloudflare.com/client/v4/zones/9b33713d659458edf28a11f984d2d5fa/dns_records/1bb386650186fdc3c278373f11353c73" \
     -H "Authorization: Bearer 4fcoJbl1EEA3hrmUtAKZeRX9blYgW6Qz-S6Kwirj" \
     -H "Content-Type: application/json" \
     --data "{\"type\":\"TXT\",\"name\":\"_dnslink.arch.j2ghz.com\",\"content\":\"dnslink=/ipfs/$HASH\",\"ttl\":1,\"proxied\":false}" | jq .

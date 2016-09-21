#!/bin/sh
set -e

echo "Starting dnsmasq..."
dnsmasq --test
dnsmasq --user=root --group=root --conf-file=/etc/dnsmasq.conf
echo "Starting sniproxy..."
sniproxy -c /etc/sniproxy/sniproxy.conf

while true; do sleep 2s; done

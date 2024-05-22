#!/bin/bash

echo "==> Setting up combo routing"
echo Mode is $1, In Int is $2, Out Int is $3, ENI is $4

# Ingress queue
tc qdisc add dev $2 handle ffff: ingress
# Routes traffic for 192.0.2.1/32
tc filter add dev $2 parent ffff: protocol ip prio 1 u32 match ip dst 192.0.2.1/32 flowid 1:1 action pass
# Drop VXLAN traffic
tc filter add dev $2 parent ffff: protocol ip prio 1 u32 match ip dport 4789 0xffff match ip protocol 17 0xff flowid 1:1 action drop
# Mirror everything
tc filter add dev $2 parent ffff: protocol all prio 2 u32 match u32 0 0 action mirred egress redirect dev $3

echo 1 > /proc/sys/net/ipv4/ip_forward
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/$2/rp_filter
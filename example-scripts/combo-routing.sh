#!/bin/bash

echo "==> Setting up combo routing"
echo Mode is $1, In Int is $2, Out Int is $3, ENI is $4

echo 1 > /proc/sys/net/ipv4/ip_forward
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/$2/rp_filter

iptables -t mangle -A PREROUTING -i $2 -d 192.0.2.1 -j MARK --set-mark 1
iptables -t mangle -A PREROUTING -i $2 -d 8.8.8.8 -j MARK --set-mark 1

tc qdisc add dev $2 handle ffff: ingress
tc filter add dev $2 parent ffff: protocol all prio 1 u32 match mark 1 0xffffffff flowid 1:1
tc filter add dev $2 parent ffff: protocol all prio 2 u32 match u32 0 0 action mirred egress redirect dev $3

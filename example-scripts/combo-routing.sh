#!/bin/bash

echo "==> Setting up combo passthrough / NAT"
echo Mode is $1, In Int is $2, Out Int is $3, ENI is $4

tc qdisc add dev $2 ingress
#tc filter add dev $2 parent ffff: protocol all prio 2 u32 match u32 0 0 flowid 1:1 action mirred egress mirror dev $3
tc filter add dev $2 parent ffff: protocol all prio 2 u32 match ip dst 10.0.0.0/8 flowid 1:1 action mirred egress redirect dev $3
tc filter add dev $2 parent ffff: protocol all prio 2 u32 match ip dst 192.168.0.0/16 flowid 1:1 action mirred egress redirect dev $3
tc filter add dev $2 parent ffff: protocol all prio 2 u32 match ip dst 172.16.0.0/12 flowid 1:1 action mirred egress redirect dev $3

iptables -F
iptables -t nat -F
iptables -t nat -A POSTROUTING -o enX0 -j MASQUERADE
iptables -A FORWARD -i $2 -o enX0 -j ACCEPT

echo 1 > /proc/sys/net/ipv4/ip_forward
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/$2/rp_filter
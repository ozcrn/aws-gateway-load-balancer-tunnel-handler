#!/bin/bash

echo "==> Setting up simple passthrough"
echo Mode is $1, In Int is $2, Out Int is $3, ENI is $4

tc qdisc add dev $2 ingress
tc filter add dev $2 parent ffff: protocol all prio 2 u32 match u32 0 0 flowid 1:1 action mirred egress redirect dev $3

#tc -s -p filter ls dev gwi-xxxxxxxx parent ffff:
#tc filter add dev gwi-oa3Pp3XOFTc parent ffff: protocol all prio 1 u32 match ip dst 1.1.1.1/32 flowid 1:1 action drop

#iptables -A PREROUTING -t mangle -i gwi-oa3Pp3XOFTc -d 10.254.2.109 -j CONNMARK --set-mark 6
#May 14 12:57:39 ip-10-255-3-57.ap-southeast-2.compute.internal kernel: IN=gwi-oa3Pp3XOFTc OUT= MAC= SRC=192.168.255.112 DST=10.254.2.109 LEN=84 TOS=0x00 PREC=0x00 TTL=61 ID=21076 PROTO=ICMP TYPE=8 CODE=0 ID=60862 SEQ=509 MARK=0x6

#tc filter add dev gwi-oa3Pp3XOFTc parent ffff: protocol all prio 2 handle 6 fw flowid 1:1 action mirred egress redirect dev gwo-oa3Pp3XOFTc

# [root@ip-10-255-3-57 ec2-user]# tc -s -p filter ls dev gwi-oa3Pp3XOFTc parent ffff:
# filter protocol all pref 2 fw chain 0
# filter protocol all pref 2 fw chain 0 handle 0x6 classid 1:1

# 	action order 1: mirred (Egress Redirect to device gwo-oa3Pp3XOFTc) stolen
# 	index 1 ref 1 bind 1 installed 1130 sec used 1130 sec
# 	Action statistics:
# 	Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
# 	backlog 0b 0p requeues 0
#!/bin/sh
# kill the DHCP server
kill `more /var/run/udhcpc.eth1.pid`
ifconfig eth1 192.168.99.10 netmask 255.255.255.0 broadcast 192.168.99.255 up

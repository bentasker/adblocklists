#!/bin/bash
cd /etc/unbound/local.d/
wget -O adblock.new "https://www.bentasker.co.uk/adblock/autolist.txt"
if [ -f adblock.conf ]
then
    mv adblock.conf adblock.old
fi

mv adblock.new adblock.conf
systemctl restart unbound

# Check whether unbound came back up
r=$( pgrep unbound | wc -l )
if [ $r -lt 1 ]
then
    mv adblock.old adblock.conf
    systemctl restart unbound
    exit 1
fi
exit 0


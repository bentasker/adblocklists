#!/bin/bash
#
# Introduced for ADBLK-8
#
# Fetch the zone only file and install it
#



wget -O manualzones.new.txt "https://www.bentasker.co.uk/adblock/zoneblocks.unbound.txt"

if [ `wc -l manualzones.new.txt | cut -d\  -f1` -gt 0 ]
then
    mv manualzones.new.txt ad-zones.conf
    service unbound reload
fi


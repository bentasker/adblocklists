#!/bin/bash
#
# Update the ads domain list



cd /etc/unbound/local.d/
rm ads.conf
for a in `wget --no-check-certificate -O - "https://www.bentasker.co.uk/adblock/autolist.txt"` 
do
echo "  local-data: \"$a A 127.0.0.2\"" >> ads.conf
echo "  local-data: \"$a IN AAAA ::1\"" >> ads.conf
done


for a in `wget --no-check-certificate -O - "https://www.bentasker.co.uk/adblock/manualblock.txt" | grep -v '#'`
do 
echo "  local-data: \"$a A 127.0.0.3\"" >> ads.conf 
echo "  local-data: \"$a IN AAAA ::1\"" >> ads.conf
done


for a in `wget --no-check-certificate -O - "https://www.bentasker.co.uk/adblock/manualzones.txt" | grep -v '#'`;
do 
echo "  local-zone: \"$a\" redirect" >> ads.conf;
echo "  local-data: \"$a IN A 127.0.0.3\"" >> ads.conf;
echo "  local-data: \"$a IN AAAA ::1\"" >> ads.conf
done
service unbound reload


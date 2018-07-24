#!/bin/bash
#
# Update the ads domain list



cd "$1"

wget -O autolist.txt "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=unbound;showintro=0&mimetype=plaintext"
wget -O minerdomains.txt https://raw.githubusercontent.com/Marfjeh/coinhive-block/master/domains 

# TODO - should move excludes into a dedicated file, but setting this up in a hurry
sed -i 's/player.h-cdn.com/#player.h-cdn.com/g' minerdomains.txt



cat minerdomains.txt | egrep -v -e '^#|^$' | while read -r domain
do

cat << EOM >> autolist.txt
local-zone: "$domain" redirect
local-data: "$domain A 127.0.0.1"
EOM

done

"$1/bin/build_abp.sh"

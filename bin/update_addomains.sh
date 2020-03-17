#!/bin/bash
#
# Update the ads domain list

cd "$1"

wget -O autolist.tmp.txt "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=unbound;showintro=0&mimetype=plaintext"
wget -O minerdomains.txt https://raw.githubusercontent.com/Marfjeh/coinhive-block/master/domains 

# TODO - should move excludes into a dedicated file, but setting this up in a hurry
sed -i 's/player.h-cdn.com/#player.h-cdn.com/g' minerdomains.txt

# Strip names out of the autolist so we can process and remove duplicates
grep "local-zone" autolist.tmp.txt | cut -d\  -f2 | sed 's/"//g' > autolist.doms.txt


# Start compiling the autolist
cat minerdomains.txt | egrep -v -e '^#|^$' | while read -r domain
do
    echo "$domain" >> autolist.doms.txt
done

cat config/manualblock.txt | egrep -v -e '^#' | while read -r domain
do
    echo "$domain" >> autolist.doms.txt
done


# Truncate the existing file
> autolist.zones.txt

# Iterate over the zones and start compiling the zone blocker
cat config/manualzones.txt | egrep -v -e '^#' | while read -r domain
do
    echo "$domain" >> autolist.zones.txt
done

# Check for any domains blocked in manualpages (i.e. no variables and no path specified)
egrep -v -e '/|\$' config/manualpages.txt | egrep -v -e '^#' | sed 's/www\.//g' | while read -r domain
do
    echo "$domain" >> autolist.zones.txt
done

# Finally process the list, and use it to build the new autolist
> blockeddomains.build.txt
cat autolist.doms.txt | sort | uniq | egrep -v -e '^$' | while read -r domain
do
    echo "$domain" >> blockeddomains.build.txt


    # Check if the domain exists within a zone that'll be blocked
    egrep -v -e "^${domain#*.}|^$domain" autolist.zones.txt > /dev/null
    if [ "$?" == "1" ]
    then

cat << EOM >> autolist.build.txt
local-data: "$domain A 127.0.0.1"
local-data: "$domain IN AAAA ::1"
EOM

    fi

done

# Block the various zones
> zoneblocks.unbound.txt
> blockedzones.txt
cat autolist.zones.txt | sort | uniq | egrep -v -e '^$' | while read -r domain
do

cat << EOM >> autolist.build.txt
local-zone: "$domain" redirect
local-data: "$domain A 127.0.0.1"
EOM


cat << EOM >> zoneblocks.unbound.txt
local-zone: "$domain" redirect
local-data: "$domain A 127.0.0.1"
EOM

echo "$domain" >> blockedzones.txt


done

mv autolist.build.txt autolist.txt
mv blockeddomains.build.txt blockeddomains.txt


# Check for any domains blocked in the social media list
> blocked_domains_with_sm.build.txt
egrep -v -e '/|\$' config/social_media_trackers.txt | egrep -v -e '^#' | sed 's/www\.//g' | while read -r domain
do
    echo "$domain" >> blocked_domains_with_sm.build.txt
done

cat blockeddomains.txt >> blocked_domains_with_sm.build.txt
mv blocked_domains_with_sm.build.txt blocked_domains_with_sm.txt


# Tidy up
rm -f autolist.zones.txt autolist.doms.txt autolist.tmp.txt blockeddomains.build.txt

"$1/bin/build_abp.sh"

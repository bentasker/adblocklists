#!/bin/bash
#
# Pull down a list of blocked zones (originally implemented in ADBLK-12)
# then translate them into regex's to feed into Pihole
#
# Add on the ADBLK-21 regexes
#
# This is better than blocking upstream, as a block in FTL will
# result in the adblock counter increasing
#
#
# Simplest setup:
#
# Save this file in root's home and configure in cron as follows
#
#  echo "0 */2 * * *    root    /root/pihole_apply_regexes.sh" | sudo tee /etc/cron.d/update_ads
#
# Copyright (c) 2020 B Tasker
# Released under GNU GPL V3 - see https://www.gnu.org/licenses/gpl-3.0.txt
# 
#

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Create a temp file
OUT="$(mktemp)"
> $OUT


# Fetch the blocked zone file
for zone in `curl -s "https://www.bentasker.co.uk/adblock/blockedzones.txt"`
do
    regex=$(echo "$zone" | sed 's~\.~\\\.~g')
    echo "^.+\.$regex\$" >> $OUT
done

for regex in `curl -s "https://www.bentasker.co.uk/adblock/regex_blocks.txt" | egrep -v -e '^$|^#' ` 
do
    echo "$regex" >> $OUT
done

# Remove any duplicates
OUT2="$(mktemp)"
cat $OUT | sort | uniq > $OUT2
mv $OUT2 $OUT


count=$(wc -l "$OUT" | cut -d\  -f1)

if [ $count -gt 0 ]
then

    # Check the files actually differ
    cd /etc/pihole
    diff -u "$OUT" regex.list > /dev/null
    if [ "$?" == "1" ]
    then
        # Files differ. Make a backup
        cp -n regex.list regex.list.old
        cat "$OUT" > regex.list

        # Tell Pihole to reload the regexes
        echo ">recompile-regex" | nc -q1 localhost 4711
    fi
fi

rm -f "$OUT"








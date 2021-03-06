#!/bin/bash
#
# Run over the blocked domains and make an ABP compatible list

DIR=${1:-$PWD}

DATE=`date +'%Y%m%d%H%M'`
DATE_FULL=`date`
cd "$DIR"

# Make sure we've got an up to date copy of the manual lists
git pull


cat << EOM > adblock_compiled.txt
[Adblock Plus 2.0]
! Version: $DATE
! Title: B Tasker
! Last modified: $DATE_FULL
! Expires: 4 days (update frequency)
! Homepage: https://www.bentasker.co.uk/adblock/
! Licence: https://www.bentasker.co.uk/licensedetails
! 
! Basically a list of ad domains that have snuck past my more traditional filters at one point or another
! 
! -----------------------General advert blocking filters-----------------------!
! *** btasker:adblock/adblock_compiled.txt ***
EOM


cat config/manualblocks/*.txt | egrep -v -e '^#|^$' | sed -e 's/^/||/' | sed -e 's/$/^*/' >> adblock_compiled.txt
cat config/manualzones.txt | egrep -v -e '^#|^$' | sed -e 's/^/||*./' | sed -e 's/$/^*/' >> adblock_compiled.txt
cat config/manualpages.txt | egrep -v -e '^#|^$' | sed -e 's/^/||/'  >> adblock_compiled.txt
cat minerdomains.txt | egrep -v -e '^#|^$' | sed -e 's/^/||*./' | sed -e 's/$/^*/' >> adblock_compiled.txt


# Create a copy without social media trackers appended
cp adblock_compiled.txt adblock_compiled_no_sm.txt



# Pull down the easylist and apply my overrides to it
curl -o easylist_modified.tmp.txt https://easylist.to/easylist/easylist.txt

# Strip out any excludes that I'm not happy with
cat config/easylist_strip.txt | sed -e 's/[\/&*\^]/\\&/g' | while read -r line
do
	sed -i "s/^@@||$line.*//g" easylist_modified.tmp.txt
done

# Strip out any excludes that I'm not happy with
cat config/easylist_strip_absolute.txt | sed -e 's/[\/&*\^]/\\&/g' | while read -r line
do
        sed -i "s/^$line.*//g" easylist_modified.tmp.txt
done


# Append my manual block
cat adblock_compiled.txt >> easylist_modified.tmp.txt

# Remove the easylist headers
sed -i 's/^!.*//g' easylist_modified.tmp.txt
sed -i 's/^\[.*//g' easylist_modified.tmp.txt


cat << EOM > easylist_modified.txt
[Adblock Plus 2.0]
! Version: $DATE
! Title: B Tasker Modified EasyList
! Last modified: $DATE_FULL
! Expires: 4 days (update frequency)
! Homepage: https://www.bentasker.co.uk/adblock/
! Licence: https://www.bentasker.co.uk/licensedetails
! 
! A modified version of easylist, incorporating additional domains I've blocked and with some exceptions removed
! 
! -----------------------General advert blocking filters-----------------------!
! *** btasker:adblock/easylist_modified.txt ***

EOM


# Add any whitelisting lines
cat config/easylist_append_lines.txt | egrep -v -e '^#|^$' >> easylist_modified.tmp.txt

# Install it in it's proper place
cat easylist_modified.tmp.txt | grep -v '^$' >> easylist_modified.txt
rm -f easylist_modified.tmp.txt


# Create a copy of the list before we add social media trackers to it
cp easylist_modified.txt easylist_modified_no_sm.txt


# Create the social media tracker blocker
cat << EOM > social_media_trackers.txt
[Adblock Plus 2.0]
! Version: $DATE
! Title: B Tasker Social media trackers
! Last modified: $DATE_FULL
! Expires: 4 days (update frequency)
! Homepage: https://www.bentasker.co.uk/adblock/
! Licence: https://www.bentasker.co.uk/licensedetails
! 
! A modified version of easylist, incorporating additional domains I've blocked and with some exceptions removed
! 
! -----------------------General advert blocking filters-----------------------!
! *** btasker:adblock/social_media_trackers.txt ***

EOM

cat config/social_media_trackers.txt | egrep -v -e '^#|^$' | sed -e 's/^/||/' | sed -e 's/$/^*/' >> social_media_trackers.txt
cat config/social_media_trackers.txt | egrep -v -e '^#|^$' | sed -e 's/^/||/' | sed -e 's/$/^*/' >> adblock_compiled.txt
cat config/social_media_trackers.txt | egrep -v -e '^#|^$' | sed -e 's/^/||/' | sed -e 's/$/^*/' >> easylist_modified.txt



Adblock lists
===============

I've been using my own amended version of EasyList for quite a while in my adblocker, and also block various ad domains at the DNS level. Changes to Easylist tend to be either overriding things they've whitelisted, or adding domains that are not yet included (and in some cases, may never be).

This repo houses both the scripts used to generate the lists as well as the configuration files. 

I've moved them into a repo primarily so I can use commit messages to record why I added a block.

The resulting lists are available at https://www.bentasker.co.uk/adblock/


Usage
-------

The scripts aren't really written for anyone but me (so may need tweaking), but if you do want to run them yourself:

* Clone the repo down somewhere (needs to be web-accessible so your blocker can fetch the lists)
* Add a cronjob to call `bin/update_addomains.sh`, the first (and only) argument should be the path to the repo

Lists should then generate and refresh automatically

To manually rebuild the adblock lists, `cd` into the repo and run `bin/build_abp.sh`


Files
-------

* _easylist_strip_absolute.txt_ - Any lines in vanilla easylist exactly matching a line in this file will be stripped
* _easylist_strip.txt_ - Any lines in vanilla easylist containing substrings in this file will be stripped
* _manualblock.txt_ - Used to block specific domains
* _manualpages.txt_ - Used to block specific pages/URLs
* _manualzones.txt_ - Used to block an entire DNS zone



License
--------

Lists and scripts are licensed under the [BSD 3 Clause License](http://opensource.org/licenses/BSD-3-Clause) and are Copyright (C) 2018 [Ben Tasker](https://www.bentasker.co.uk)

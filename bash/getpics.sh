#!/bin/bash
#
# this script gets some picture files for our personal web pages, which are kept in public_html
# the pictures are put into a subdirectory of public_html named pics
# it does some error checking
# it summarizes the public_html/pics directory when it is done
#
# It should not be run as root
[ "`whoami`" = "root" ] && echo "Not to be run as root" && exit 1

# Task 1: Improve this script to also retrieve and install the files kept in the https://zonzorp.net/pics.tgz tarfile
#   - use the same kind of testing that is already in the script to only download the tarfile if you don't already have it and
#     to make sure the download and extraction commands work
#     then delete the local copy of the tarfile if the extraction was successful

# make sure we have a clean pics directory to start with
rm -rf ~/Pictures
mkdir -p ~/Pictures || (echo "Failed to make a new pics directory" && exit 1)

# download a zipfile of pictures to our Pictures directory - assumes you are online
# unpack the downloaded zipfile if the download succeeded - assumes we have an unzip command on this system
# delete the local copy of the zipfile after a successful unpack of the zipfile
# Task 1: Improve this script to also retrieve and install the files kept in the https://zonzorp.net/pics.tgz tarfile
#     test to make sure the download and extraction commands work
#     then delete the local copy of the tarfile if the extraction was successful
wget -O ~/COMP2101/bash/pics.tgz https://zonzorp.net/pics.tgz && tar xvf pics.tgz && rm ~/COMP2101/bash/pics.tgz
# Make a report on what we have in the Pictures directory
test -d ~/COMP2101/bash/pics && cat <<EOF
Found $(find ~/COMP2101/bash/pics -type f|wc -l) files in the pics directory.
The pics directory uses $(du -sh ~/COMP2101/bash/pics|awk '{print $1}') space on the disk.
EOF

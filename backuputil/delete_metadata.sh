#!/bin/sh
echo "Searching for Thumbs.db Windows thumbnail metadata"
find $1 -name 'Thumbs.db' -exec rm -vf {} \;
echo "Delete Linux core dump files"
find $1 -regex '.*/core.[0-9][0-9][0-9][0-9]$' -exec rm -vf {} \;
echo "Searching for .DS_Store Macintosh metadata"
find $1 -name '.DS_Store' -exec rm -vf {} \;
echo "Searching for ._* Macintosh metadata"
find $1 -name '._*' -exec rm -vf {} \;
echo "Searching for *~ backups"
find $1 -name '*~' -exec rm -vf {} \;
echo "Checking for .TemporaryItems/ in" $1
if [ -e $1/.TemporaryItems/ ]; then
  rm -rfv $1/.TemporaryItems/
fi


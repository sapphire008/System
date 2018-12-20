#! /usr/bin/bash

# Contribute to source and destination folders back and forth

# echo on both sides without deleteing
folder1="/cygdrive/d/Edward/Documents/Assignments/Case Western Reserve/StrowbridgeLab/"
folder2="/cygdrive/x/Edward/Documents/"

INCLUDE="" # don't exclude files matching these patterns. Include overwrites EXCLUDE below
EXCLUDE="lost+found .identity core.* .dropbox* ._Library .*DS_Store SyncToy*.dat Thumbs.db *.one LabWorld"

# Check if folder exists
if [ ! -d "${folder1}" ]; then
  echo "${folder1} does not exists"
  exit 0
fi

if [ ! -d "${folder2}" ]; then
  echo "${folder2} does not exists"
  exit 0
fi

# generate a list of items to include before exclusion
if [ ! -z "$INCLUDE" ]; then
  INCLUDED="--include='*/'"
  for i in $INCLUDE; do
      INCLUDED="$INCLUDED --include=$i";
  done
fi
# generate a list of items to ignore
if [ ! -z "$EXCLUDE"  ]; then
  EXCLUDED=""
  for i in $EXCLUDE; do
    EXCLUDED="$EXCLUDED --exclude=$i";
  done
fi

# Backup back and forth
echo "Starting backup with command: rsync $INCLUDED $EXCLUDED -auv \"${folder1}\" \"${folder2}\""
rsync $INCLUDED $EXCLUDED -auv --no-perms --no-owner --no-group --no-D "${folder1}" "${folder2}"
echo "Starting backup with command: rsync $INCLUDED $EXCLUDED -auv \"${folder2}\" \"${folder1}\""
rsync $INCLUDED $EXCLUDED -auv --no-perms --no-owner --no-group --no-D "${folder2}" "${folder1}"

#! /usr/bin/bash

# Contribute to source and destination folders, order does not matter here
SELECT=("Assignments" "PDF" "Books" "StrowbridgeLab") # "EndNote"   "Pictures" "PDF" "Books"
# cygdrive version: echo on both sides without deleteing
# SOURCE=("/cygdrive/d/Edward/Documents/Assignments/" "/cygdrive/d/Edward/Documents/Books/" "/cygdrive/d/Edward/Documents/EndNote/" "/cygdrive/d/Edward/Documents/PDF/" "/cygdrive/d/Edward/Documents/Ubuntu/" "/cygdrive/d/Edward/Saved Games/" "/cygdrive/d/Edward/Music/" "/cygdrive/d/Edward/Pictures/" "/cygdrive/d/Edward/Software/")
# DESTINATION=("/cygdrive/h/Edward/Documents/Assignments/" "/cygdrive/h/Edward/Documents/Books/" "/cygdrive/h/Edward/Documents/EndNote/" "/cygdrive/h/Edward/Documents/PDF/" "/cygdrive/h/Edward/Documents/Ubuntu/" "/cygdrive/h/Edward/Games/" "/cygdrive/h/Edward/Music/" "/cygdrive/h/Edward/Pictures/" "/cygdrive/h/Edward/Software/")

SOURCE=("/mnt/d/Edward/Documents/Assignments/" "/mnt/d/Edward/Documents/Books/" "/mnt/d/Edward/Documents/EndNote/" "/mnt/d/Edward/Documents/PDF/" "/mnt/d/Edward/Documents/Ubuntu/" "/mnt/d/Edward/Saved Games/" "/mnt/d/Edward/Music/" "/mnt/d/Edward/Pictures/" "/mnt/d/Edward/Software/" "/mnt/d/Edward/Documents/Assignments/Case Western Reserve/StrowbridgeLab")
DESTINATION=("/mnt/h/Edward/Documents/Assignments/" "/mnt/h/Edward/Documents/Books/" "/mnt/h/Edward/Documents/EndNote/" "/mnt/h/Edward/Documents/PDF/" "/mnt/h/Edward/Documents/Ubuntu/" "/mnt/h/Edward/Games/" "/mnt/h/Edward/Music/" "/mnt/h/Edward/Pictures/" "/mnt/h/Edward/Software/" "/mnt/h/Edward/Documents/Assignments/Case Western Reserve/StrowbridgeLab")

ID=("Assignments" "Books" "EndNote" "PDF" "Ubuntu" "Games" "Music" "Pictures" "Software" "StrowbridgeLab")
OPT=("contribute" "contribute" "contribute" "contribute" "contribute" "contribute" "contribute" "contribute" "contribute" "sync") # options: sync (complete synchronization); contribute (only add to the destination), union (add missing files from target to destination AND from destination to target)
INCLUDE="" # don't exclude files matching these patterns. Include overwrites EXCLUDE below
EXCLUDE="lost+found .identity core.* .dropbox* ._Library .*DS_Store SyncToy*.dat Thumbs.db"

# backup function
rsync_backup_fun(){
  # usage: rsync_backup_fun source destination
  # Check if folder exists
  if [ ! -d "$1" ]; then
    echo "$1 does not exists"
    exit 0
  fi

  if [ ! -d "$2" ]; then
    echo "$2 does not exists"
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

  # Do Backup
  if [ "$3" == "sync" ]; then
    echo "Starting backup with command: rsync $INCLUDED $EXCLUDED -auv --no-perms --no-owner --no-group --no-D --delete \"$1\" \"$2\""
    rsync $INCLUDED $EXCLUDED -auv --no-perms --no-owner --no-group --no-D --delete "$1" "$2"
  elif [ "$3" == "contribute" ]; then
    echo "Starting backup with command: rsync $INCLUDED $EXCLUDED -auv --no-perms --no-owner --no-group --no-D \"$1\" \"$2\""
    rsync $INCLUDED $EXCLUDED -auv --no-perms --no-owner --no-group --no-D "$1" "$2"
  elif [ "$3" == "union" ]; then
    echo "Starting backup with command: rsync $INCLUDED $EXCLUDED -auv --no-perms --no-owner --no-group --no-D \"$1\" \"$2\""
    rsync $INCLUDED $EXCLUDED -auv --no-perms --no-owner --no-group --no-D --delete "$1" "$2"
    echo "Starting backup with command: rsync $INCLUDED $EXCLUDED -auv --no-perms --no-owner --no-group --no-D \"$2\" \"$1\""
    rsync $INCLUDED $EXCLUDED -auv --no-perms --no-owner --no-group --no-D --delete "$2" "$1"
  fi
}

function array_find() {
    array=$1[@]
    seeking=$2
    a=("${!array}")
    val=-1

    for i in "${!a[@]}" ; do
        if [[ "${a[$i]}" == $seeking ]]; then
          val=$i
          break
        fi
    done
    echo $val
}

# Transverse through the list of folder pairs
# for j in "${!SOURCE[@]}"; do
#   rsync_backup_fun "${SOURCE[$j]}" "${DESTINATION[$j]}"
# done

# Run selected backup
for j in "${SELECT[@]}"; do
  ind=$(array_find ID $j)
  if [[ $ind -gt -1 ]]; then
    echo "rsync_backup_fun" "${SOURCE[$ind]}" "${DESTINATION[$ind]}" "${OPT[$ind]}"
    rsync_backup_fun "${SOURCE[$ind]}" "${DESTINATION[$ind]}" "${OPT[$ind]}"
  fi
done

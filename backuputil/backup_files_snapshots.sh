#!/bin/bash
# Nick Masluk
# last updated 2014-03-17

# Note:  FILES_PATH and BACKUP_FILES_PATH must both contain a file with filename .identity for this script to run
FILES_PATH="/hsgs/projects/jhyoon1/"
BACKUP_FILES_PATH="/nfs/backup/"
SNAPSHOTS_KEEP="16" # set to 0 to disable deleting old snapshots
INCLUDE="*average*.nii" # don't exclude files matching these patterns
EXCLUDE="lost+found .identity core.* .dropbox* PFC_basal* ._Library .*DS_Store .*TemporaryItems* .bash_history* tarballs* rra*.nii *resample*.nii *resample*.tgz *resample*.gz 4D*"
LOG_FILE="/nfs/backup/logs/backup_files_log_"`date +%F`".txt"
KEEP_LOG="1" # set to 0 to disable, 1 to keep a running log, 2 to delete the log and record only current session
LOCK_FILE="/nfs/backup/.backup_files_running"
#The first thing the script does is check for the presence of the file specified in LOCK_FILE.
#This file prevents the script from running in multiple instances.
#If the file exists, the script will abort, otherwise it will create that file, run the backup,
#then delete the file once the backup is completed. If the script refuses to run because this file is present,
#but no instances of the script exist, it is likely because the script was aborted while running and did not
#have a chance to clean up after itself (and in this case, the file specified in LOCK_FILE may be deleted manually,
#to allow the script to run).

# Check if a backup is already running.  If not, create file $LOCK_FILE to
# indicate to other instances of this script that a backup is running.
if [ ! -e $LOCK_FILE ]; then
  touch $LOCK_FILE
else
  echo "Backup is already running"
  # exit with error code 2 if a backup is already running
  exit 2
fi

# check that .identity exists on the root of the files and backup directories (Mac only)
check_identity() {
  if [ ! -e $FILES_PATH/.identity ] || [ ! -e $BACKUP_FILES_PATH/.identity ]; then
    date +%F\ %T\ %A | $LOG_CMD

    echo "" | $LOG_CMD
    if [ ! -e $FILES_PATH/.identity ]; then
      echo $FILES_PATH "is missing .identity file" | $LOG_CMD
    fi
    if [ ! -e $BACKUP_FILES_PATH/.identity ]; then
      echo $BACKUP_FILES_PATH "is missing .identity file" | $LOG_CMD
    fi

    # remove $LOCK_FILE to indicate the script is done running
    rm -f $LOCK_FILE
    echo "" | $LOG_CMD
    echo "--------------------------------------------------------------------------------" | $LOG_CMD
    exit 3
  fi
}

set_dirs() {
  date +%F\ %T\ %A | $LOG_CMD
  echo "" | $LOG_CMD

  # directory where last complete backup is located
  LAST_BACKUP_DIR=`ls $BACKUP_FILES_PATH | sort | grep ^"....-..-.._..\...\..."$ | tail -1`
# for some reason -n never returned false when the string was ""
#  if [ -n $LAST_BACKUP_DIR ]; then
  if [[ $LAST_BACKUP_DIR != "" ]]; then
    echo "Last completed backup is located in" $LAST_BACKUP_DIR | $LOG_CMD
  else
    echo "No previous backup found, all files will be newly copied" | $LOG_CMD
  fi
  # directory where this finalized backup will reside
  CURRENT_BACKUP_DIR=`date +%F_%H.%M.%S`
  echo "This backup will reside in" $CURRENT_BACKUP_DIR "if completed" | $LOG_CMD

  # check if incomplete backups exist
  if [[ `ls $BACKUP_FILES_PATH | sort | grep ^"tmp\.....-..-.._..\...\..."$ | wc -l` -eq 0 ]]; then
    # temporary location for backup while backup is running
    TEMP_BACKUP_DIR=tmp.`date +%F_%H.%M.%S`
    mkdir $BACKUP_FILES_PATH/$TEMP_BACKUP_DIR
  else
    if [[ `ls $BACKUP_FILES_PATH | sort | grep ^"tmp\.....-..-.._..\...\..."$ | wc -l` -gt 1 ]]; then
      echo "More than one partial backup exists, cancelling backup" | $LOG_CMD
      # if more than one partial backup exists, terminate backup
      # remove $LOCK_FILE to indicate the script is done running
      rm -f $LOCK_FILE
      echo "" | $LOG_CMD
      echo "--------------------------------------------------------------------------------" | $LOG_CMD
      exit 4
    else
      # set temporary backup location to that of the partially completed backup
      TEMP_BACKUP_DIR=`ls $BACKUP_FILES_PATH | sort | grep tmp.`
      echo "A partial backup exists in" $TEMP_BACKUP_DIR "and will resume now" | $LOG_CMD
    fi
  fi
}

run_backup() {
  # generate a list of items to include before exclusion
  INCLUDED="--include='*/'"
  for i in $INCLUDE; do
      INCLUDED="$INCLUDED --include=$i";
  done
  # generate a list of items to ignore
  EXCLUDED=""
  for i in $EXCLUDE; do
    EXCLUDED="$EXCLUDED --exclude=$i";
  done

  echo "" | $LOG_CMD
  echo "Starting rsync backup, from" $FILES_PATH "to" $BACKUP_FILES_PATH | $LOG_CMD
  rsync $INCLUDED $EXCLUDED --delete-after -av --link-dest=$BACKUP_FILES_PATH/$LAST_BACKUP_DIR/ $FILES_PATH $BACKUP_FILES_PATH/$TEMP_BACKUP_DIR/ 2>&1 | $LOG_CMD
  # store error code from rsync's exit
  ERROR=${PIPESTATUS[0]}
  # if rsync succeeds, move the temporary backup location to its final location
  # if there is Permission Denied error from rsync, still move the backup to final location
  if [ $ERROR == 0 ] || [ $ERROR == 13]; then
    mv $BACKUP_FILES_PATH/$TEMP_BACKUP_DIR $BACKUP_FILES_PATH/$CURRENT_BACKUP_DIR
  fi
}

find_removed() {
  echo "" | $LOG_CMD
  echo "Files removed since last backup:" | $LOG_CMD
  # run a dry rsync run between current and previous backups to determing which files were removed
  rsync $EXCLUDED --delete-before -avn $BACKUP_FILES_PATH/$CURRENT_BACKUP_DIR/ $BACKUP_FILES_PATH/$LAST_BACKUP_DIR/ | grep ^"deleting " | cut --complement -b 1-9 | $LOG_CMD
}

del_old_snapshots() {
  if [ $SNAPSHOTS_KEEP -gt 0 ]; then # disable deleting snapshots if SNAPSHOTS=0
    NUMBER_SHOTS=`ls $BACKUP_FILES_PATH | sort | grep -v lost+found | wc -l`
    NUMBER_DEL=0
    if [ $NUMBER_SHOTS -gt $SNAPSHOTS_KEEP ]; then
      NUMBER_DEL=$(($NUMBER_SHOTS - $SNAPSHOTS_KEEP))
      echo ""| $LOG_CMD
      echo "Removing" $NUMBER_DEL "old backups" | $LOG_CMD
    fi
    for OLD_DIR in $(ls $BACKUP_FILES_PATH | sort | grep -v lost+found | head -$NUMBER_DEL) ; do
      echo "Removing" $BACKUP_FILES_PATH/$OLD_DIR | $LOG_CMD
      rm -rf $BACKUP_FILES_PATH/$OLD_DIR
    done
  fi
}

delete_metadata() {
  echo "Searching for Thumbs.db Windows thumbnail metadata"
  find $FILES_PATH -name 'Thumbs.db' -exec rm -vf {} \;
  echo "Delete Linux core dump files"
  find $FILES_PATH -regex '.*/core.[0-9][0-9][0-9][0-9]$' -exec rm -vf {} \;
  echo "Searching for .DS_Store Macintosh metadata"
  find $FILES_PATH -name '.DS_Store' -exec rm -vf {} \;
  echo "Searching for ._* Macintosh metadata"
  find $FILES_PATH -name '._*' -exec rm -vf {} \;
  echo "Searching for *~ suffixed backups"
  find $FILES_PATH -name '*~' -exec rm -vf {} \;
  echo "Checking for .TemporaryItems/ in" $FILES_PATH
  if [ -e $FILES_PATH/.TemporaryItems/ ]; then
    rm -rfv $FILES_PATH/.TemporaryItems/
  fi
}

if [ $KEEP_LOG -eq 1 ] || [ $KEEP_LOG -eq 2 ]; then
  # run backup logged
  if [ $KEEP_LOG -eq 2 ] && [ -e $LOG_FILE ]; then
    # if log mode is set to "2", delete old log file before starting (if it exists)
    rm -f $LOG_FILE
  fi
  # set log command to split stdout into a log file and stdout
  LOG_CMD="tee -a $LOG_FILE"
else
  # set log command to only print to stdout
  LOG_CMD="cat"
fi


# check that .identity files exist in files and backup directories (Mac only)
# check_identity
# Delete some meta data before backup
delete_metadata
# set directory locations of backup
set_dirs
# run rsync backup
run_backup
# find files which have been removed since last backup
find_removed
# remove old snapshots
del_old_snapshots
# remove $LOCK_FILE to indicate the script is done running
rm -f $LOCK_FILE

echo "" | $LOG_CMD
date +%F\ %T\ %A | $LOG_CMD
echo "--------------------------------------------------------------------------------" | $LOG_CMD
# exit with the error code left by rsync
exit $ERROR

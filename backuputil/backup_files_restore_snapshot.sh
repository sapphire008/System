!/bin/bash
# Nick Masluk
# last updated 2011-03-29
#
# Restores the latest backup in $BACKUP_FILES_PATH to $FILES_PATH

# Note:  FILES_PATH and BACKUP_FILES_PATH must both contain a file with filename .identity for this script to run
FILES_PATH=$HOME"/files/"
BACKUP_FILES_PATH=$HOME"/files_backup/"
EXCLUDE="lost+found .identity"
LOG_FILE=$HOME"/logs/backup_files_log.txt"
KEEP_LOG="1" # set to 0 to disable, 1 to keep a running log, 2 to delete the log and record only current session
LOCK_FILE=$HOME"/.backup_files_running"

# Check if a backup is already running.  If not, create file $LOCK_FILE to
# indicate to other instances of this script that a backup is running.
if [ ! -e $LOCK_FILE ]; then
  touch $LOCK_FILE
else
  echo "Backup is already running"
  # exit with error code 2 if a backup is already running
  exit 2
fi

# check that .identity exists on the root of the files and backup directories
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
    echo "No backups found!" | $LOG_CMD
    # remove $LOCK_FILE to indicate the script is done running
    rm -f $LOCK_FILE
    echo "" | $LOG_CMD
    echo "--------------------------------------------------------------------------------" | $LOG_CMD
    exit 4
  fi
}

# run rsync backup
run_backup() {
  # generate a list of items to ignore
  EXCLUDED=""
  for i in $EXCLUDE; do
    EXCLUDED="$EXCLUDED --exclude=$i";
  done

  ID_FILES=`cat $FILES_PATH/.identity`
  ID_BACKUP_FILES=`cat $BACKUP_FILES_PATH/.identity`
  echo "" | $LOG_CMD
  echo "Starting rsync backup restore, from" $ID_BACKUP_FILES "to" $ID_FILES | $LOG_CMD
  rsync $EXCLUDED --delete-after -av $BACKUP_FILES_PATH/$LAST_BACKUP_DIR/ $FILES_PATH 2>&1 | $LOG_CMD
  # store error code from rsync's exit
  ERROR=${PIPESTATUS[0]}
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

# check that .identity files exist in files and backup directories
check_identity
# set directory locations of backup
set_dirs
# run rsync backup
run_backup
# remove $LOCK_FILE to indicate the script is done running
rm -f $LOCK_FILE
# exit with the error code left by rsync
exit $ERROR


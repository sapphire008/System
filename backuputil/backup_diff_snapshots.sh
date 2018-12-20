#!/bin/bash
# Nick Masluk
# last updated 2011-03-29

FILES_PATH="/hsgs/projects/jhyoon1/"
BACKUP_FILES_PATH="/nfs/backup/"
LOG_FILE="/nfs/backup/logs/backup_diff_"`date +%F`".txt"
KEEP_LOG="1" # set to 0 to disable, 1 to keep a running log, 2 to delete the log and record only current session

if [ $KEEP_LOG -eq 1 ] || [ $KEEP_LOG -eq 2 ]; then
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

date +%F\ %T\ %A | $LOG_CMD
# directory where last complete backup is located
LAST_BACKUP_DIR=`ls $BACKUP_FILES_PATH | sort | grep ^"....-..-.._..\...\..."$ | tail -1`
echo "Last completed backup is located in" $LAST_BACKUP_DIR | $LOG_CMD
echo 'Starting backup diff between' `cat $FILES_PATH/.identity` 'and' `cat $BACKUP_FILES_PATH/.identity` | $LOG_CMD
diff -rq $FILES_PATH $BACKUP_FILES_PATH/$LAST_BACKUP_DIR 2>&1 | $LOG_CMD
# record error code left by diff
ERROR=${PIPESTATUS[0]}
date +%F\ %T\ %A | $LOG_CMD
echo "--------------------------------------------------------------------------------" | $LOG_CMD
# exit with error code left by diff
exit $ERROR

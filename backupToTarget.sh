#!/bin/bash
BACKUP_SOURCES="/data"
curDir=`dirname "$0"`

#//TODO implement '--dry-run' option

#Check for backup target argument
if [ $# -eq 0 ]; then
  echo "Must specify USB drive label"
  exit 1
fi

#check that backup target exists
drivePath=`realpath $1`

if [ ! -d "$drivePath" ];
then
  echo "Target directory '${usbDrive}' is not available!"
  exit 1
fi

#initialize backup directory
backupPath="${drivePath}/backup"
mkdir -p "${backupPath}"

backupList=()

#check that backup sources are valid
for source in ${BACKUP_SOURCES}; do
  source=`realpath $source`
  
  #if source exists, make sure it can be read
  if [ -e "$source" ]; then
    if [ -r "$source" ]; then
      echo "Adding '${source} to backup list..."
      backupList+=($source)
    else
      echo "Unable to read desired backup source '$source'. Exiting"
      exit 1
    fi

  #if source no longer exists, ask if user would like to delete it from the target
  else
    echo "WARN: Desired backup source '$source' does not exist."
    
    #Check if exists
    if [ -e "${backupPath}${source}" ]; then
      read -p "Would you like to remove it from the target device? [y/n]:" -n 1 -r
      echo
      #delete from target if requested
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "Deleting '${backupPath}${source}'..."
        rm -rf "${backupPath}${source}"
        if [ ! $? -eq 0 ]; then
          echo "Error deleting '${source}' from target! Check error log"
          exit 1
        fi
      fi
    fi
  fi 
done

#begin backup
for source in ${backupList}; do
  echo -n "Backing up '$source' to '${backupPath}${source}'..."

  rsync -qa --delete "$source" "${backupPath}" 2> "${curDir}/errors.txt"
  if [ $? -eq 0 ]; then
    echo "Done."
  else
    echo "Error! Check error log"
    echo "Exiting..."
    exit 1;
  fi
done

echo "Last successful backup finished on: $(date)" | tee "${drivePath}/lastbackup.txt"

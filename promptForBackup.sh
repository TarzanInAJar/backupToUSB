TARGET_DIR=$1
ALIAS=$2

if [ -e $TARGET_DIR ]; then
  echo "$ALIAS detected!"
else
  echo "$ALIAS NOT detected. Is it plugged in?"
fi

read -p "Would you like to run your $ALIAS backup? [y/n]:" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  /home/ryan/backup/backupToTarget.sh $TARGET_DIR
else
  exit 0
fi

read -p "Press any key to continue..." -n 1 -r -s
echo

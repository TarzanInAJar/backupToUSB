TARGET_DIR=$1
ALIAS=$2

curDir=`dirname "$0"`

promptBeforeExit() {
  read -p "Press any key to continue..." -n 1 -r -s
  echo
  exit $1
}

if [ -z $TARGET_DIR ]; then
  echo "Must specify target directory!"
  promptBeforeExit 1
fi

if [ -z $ALIAS ]; then
  ALIAS=$TARGET_DIR
fi


while : ; do

  if [ ! -d $TARGET_DIR ]; then
    echo -n "Giving a chance for drives to mount..."
    sleep 5
    echo "done"
  fi

  if [ -d $TARGET_DIR ]; then
    echo "$ALIAS detected!"
    break
  else
    read -p "$ALIAS NOT detected. Try again? [y/n]" -n 1 -r -s
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || exit 1
  fi
done

read -p "Would you like to run your $ALIAS backup? [y/n]:" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo su -c "${curDir}/backupToTarget.sh $TARGET_DIR"
else
  exit 0
fi

promptBeforeExit

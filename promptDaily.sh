read -p "Would you like to run your daily backup? [y/n]:" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  /home/ryan/backup/backupToUSB.sh BreadboxDaily
else
  exit 0
fi

read -p "Press any key to continue..." -n 1 -r -s



zpool status -v atlas 
echo " " 
zpool iostat -vyl
echo " " 
zfs list -t filesystem 
echo " " 
zfs get compressratio -o all -t filesystem
echo " "
zfs list -t snapshot

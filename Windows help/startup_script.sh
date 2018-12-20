# Run upon log in:
# Exit root if current user is root
if whoami==root
then
	exit
fi
# mount my 12TB RAID array file system to a root folder:  must use sudo
echo kuku1234@malu() | sudo mount /dev/sda2 /nfs
# mount a remote folder on Mac Mini: Do not use sudo
echo Neurologia2 | sshfs Mini_user@171.65.46.54:/Users/Shared/SSHFS_Shared/ /mnt/Mac_Mini_Shared/ -o fsname=ssh -o password_stdin

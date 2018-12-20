# How to mount a remote directory via sshfs
1. Install `sshfs`
	```
	sudo apt-get install sshfs
	```
2. Create a folder as mount point
	```
	sudo mkdir /mnt/Mac_Mini_Shared
	```
3. chown this directory
	```
	sudo chown -R usr:group /mnt/Mac_Mini_Shared/
	```
4. Exit if currently root, then mount the remote folder.
	Do not use `sudo` in this step, as it may mess up the permission
	```
	sshfs Mini_user@171.65.46.54:/Users/ /mnt/Mac_mini_Shared/
	```
*format:*
```
sshfs usr@remote.host.address:/remote/directory/ /local/mount/point
```
With some additional options here
```
sshfs -o uid=$UID,allow_other,default_permissions usr@remote.host.address:/remote/directory /local/mount/point
```
where `-o` tells the sshfs to use the following options:

	`uid=$UID` : set mount user ID to be local computer ID

	`allow_other` : allow other users to share the mount. Make sure do `sudo chmod 775 /etc/fuse.conf` beforehand

	`default_permission` : use the permission of the remote server

# How to connect to Proclus
The following several items use this link as reference
https://www.stanford.edu/group/proclus/cgi-bin/mediawiki/index.php/LoggingIn
1. Loggin in to Proclus
	```
	ssh -X your_sunetid@proclus.stanford.edu
	```
	Enter your SUnet ID password

	If this is the first time you log in, it will ask you to genereate a public authentication key. Enter a password twice here and remeber it.

	If you use a Mac, make sure you have `XQuartz` installed
2. Check X11 forwarding display
	```
	echo $DISPLAY
	xclock
	```
	A clock should be running on the local desktop, if forwarding is correct
3. Starting an interactive `X11` session on a computer node
	```
	qlogin
	```
	which should give you 5G hard memory. if you want to request more, use
	```
	qlogin -l h_vmem=10G
	```
	To check how much memory on the node,
	```
	qstat -f -F h_vmem | less
	```
	press Q when finished checking

	To check cluster slot summary by queue
	```
	qstat -g c
	```
	show available memory on each host
	```
	qhost -F mem_free
	```
	show all jobs in the system
	```
	qstat -f -u \*
	```
*The following several items use this link as reference:https://www.stanford.edu/group/proclus/cgi-bin/mediawiki/index.php/Software-R*
4. Start software (interactive)
	To check what modules/software are available
	```
	module avail
	```
	To load the software, for instance, MATLAB
	```
	module load MATLAB-R2012b
	matlab &
	```
	Note that there may be many versions of the same software. We need to type in the exact name of listed modules from "module avail"

5. Mount local directories onto the server
	Make sure `sshfs` package is installed. Create a mount point. Then,
	```
	sshfs your_sunetid@proclus.stanford.edu:/hsgs/projects/jhyoon1/ /Users/Mini_users/Desktop/Proclus_mount
	```

	Use `rsync` to transfer data between the server and local machine

6. Submtting and monitoring long jobs
	To submit a job
	```
	qsub /full/path/to/job/script
	```
	Use `qstat` to monitor the job status
	To see only current user's job
	```
	qstat -u "{user_name}"
	```
	To see how much memory a specific job is requested
	```
	qstat -f -j JOBID
	```
7. To see a list of jobs open
	```
	qstat -f -u '*'|grep QLOGIN|sort -n -k 6
	qstat -f -u '*'|grep vncviz|sort -n -k 6
	qstat -f -u '*'|grep batch|sort -n -k 6
	```

8. To close the jobs, locate the job id and do
	```
	qdel 0000000
	```


# How to set up `openssh` public key authetication

## Host: https://help.ubuntu.com/community/SSH/OpenSSH/Configuring
1. Make a backup for the setting
	```
	sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory_setting
	```
2. edit settings
	```
	sudo nano /etc/ssh/sshd_config
	```
3. Disable password authentication
	Replace
	```
	#PasswordAuthentication yes
	```
	with
	```
	PasswordAuthentication no
	```
4. Disable forwarding

	To disable forwarding, look for the following lines in your sshd_config:
	```
	AllowTcpForwarding yes
	...
	X11Forwarding yes
	```
	and replace them with:
	```
	AllowTcpForwarding no
	...
	X11Forwarding no
	```
5. Allow/Deny users
	To allow only the users Fred and Wilma to connect to your computer, add the following line to the bottom of the sshd_config file:
	```
	AllowUsers Fred Wilma
	```
	To allow everyone except the users Dino and Pebbles to connect to your computer, add the following line to the bottom of the sshd_config file:
	```
	DenyUsers Dino Pebbles
	```
6. Log more information
	To increase the level, find the following line in your sshd_config:
	```
	LogLevel INFO
	```
	and change it to this:
	```
	LogLevel VERBOSE
	```
7. Restart the ssh service
	```
	sudo service ssh restart
	```

## Client: Generate Public Authentication Key
1. Make a folder
```
sudo mkdir ~/.ssh
```
2. Give it proper permission
```
chmod 700 ~/.ssh
```
3. Generate the key
```
cd ~/.ssh
ssh-keygen -t rsa
```
4. The follwing will be shown. Enter a strong password as required
```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/b/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/b/.ssh/id_rsa.
Your public key has been saved in /home/b/.ssh/id_rsa.pub.
```
5. Transfer the key to the host. Concatenate the key with the `authorized_keys` file
under `~/.ssh/  directory`


# workgroup management
Go to `workgroup.stanford.edu`. If you are an administration, you can add and remove people's SUNet ID from our group. You can also dub other users as administration as well.

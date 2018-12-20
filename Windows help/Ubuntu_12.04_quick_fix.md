# How to install MATLAB
1. cd to the downloaded file folder
2. unzip `matlab_R2012b_glnxa64.installer.zip` or something similar
3. There will be a install file, simply run it by typing
```
sudo ./install
```
4. Follow the instructions
5. Install additional compiler support:http://www.mathworks.com/support/compilers/R2012a/glnxa64.html
Installing compilers: https://help.ubuntu.com/community/InstallingCompilers
  * Installing the GNU C compiler and GNU C++ compiler
  ```
  sudo apt-get update
  sudo apt-get upgrade
  sudo apt-get install build-essential
  gcc -v
  make -v
  ```
  * Installing the GNU Java compiler.
    * Download the jdk from java website
    * untar it under /usr/local/lib/java
6. Make a symbolic link of MATLAB so that it is executable in the terminal

```
sudo ln -s /usr/local/MATLAB/R2012b/bin/matlab /usr/local/bin
```

# How to install ITK-Snap
1. Download the binary package and untar it
2. Move the content of bin folder to `/usr/local/bin`
3. Move the content of lib folder to `/usr/local/lib`
4. If there is a problem with `libjpeg62`

```
sudo apt-get install libjpeg62 git-core
```

# How to install Anaconda Python distribution
1. Download the package and in the terminal,
bash anaconda.sh
2. Carefully hit enter to skim through the agreement; at last line, type in "yes" to agree
3. select a installation path, for instance:
```
/usr/local/pkg64/pythonpackages/anaconda
```
make sure the last folder is `anaconda` so that all contents will be unzipped into this folder
4. Add the path of anaconda to the environment `PATH` variable
```
export PATH=$PATH:/usr/local/pkg64/pythonpackages/anaconda
```

  change the path after the colon to the path of anaconda accordingly
  Alternatively, change the following lines in `~/.profile`

  Set `PATH` so it includes user's private bin if it exists
```
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH:/usr/local/pkg64/pythonpackages/anaconda"
fi
```

5. Add conda command to bin for easier issue of the command
```
sudo ln -s /usr/local/pkg64/pythonpackages/anaconda/bin/conda /usr/local/bin/conda
```

# How to install R
```
sudo nano /etc/apt/sources.list
```
add a line at the end
```
deb http://cran.cnr.Berkeley.edu/bin/linux/ubuntu precise/
```
or replace the url with the correct server and version of ubuntu
```
sudo apt-get update
sudo apt-get install r-base
```

Then install r-studio
http://www.rstudio.com/ide/download/desktop

# VirtualBox
1. To enable full screen in VirtualBox, under "Devices", select insert guest addition media; Then in the guest OS, install the guest addition features (should be loaded as a CD-ROM).
2. To create shared folders
In settings-->shared folders, create a shared folder in the host OS
Then in the guest OS:(https://help.ubuntu.com/community/VirtualBox/SharedFolders)
  * If the guest is Windows, in the command prompt
  ```
  net use x: \\vboxvr\share
  ```
  where "share" is the name of the folder created previously for sharing
  * If this does not work,try
  ```
  net use x: \\vboxsvr\share
  ```
  * If the guest is Ubuntu
  ```
  sudo mount -t vboxsf -o uid=$UID,gid=$GID share ~/host
  ```
where `share` is the name of the folder created previously for sharing
where `~/host` is where you want to mount the shared folder to
  * If `vboxsf` does not work, try `vboxfs`
3. To enable USB detection
After installing Guest addition, in the host system, add your username to the group `vboxusers`
In Ubuntu or any Unix,
```
sudo usermod -aG vboxusers <your-user-name>
```
Log out and log back in to finalize the modification


# How to add Microsoft font to Ubuntu
In the software center, search for `ttf-mscorefonts`

Install the package

# How to make a bootable USB drive (MacOSX)
http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-mac-osx

1. Have Ubuntu Desktop downloaded
2. Open terminal, type in
```
hdiutil convert -format UDRW -o ~/path/to/target.img ~/path/to/ubuntu.iso
```
  This will convert the .iso image to a .img image. Make sure remove the .dmg file appended by OSX

3. run diskutil get the attached USB drive stick, note the drive (something like `/dev/disk2`)

4. umount the USB drive by doing
```
diskutil unmountDisk /dev/disk2
```
  (or replace any disk number you saw under the disk utiliy)

5. Make sure the USB drive has been formatted, then write the image to the drive:
  ```
  sudo dd if=/path/to/target.img of=/dev/rdisk2 bs=1m
  ```
6. After completion, safely remove the USB drive. An USB bootable drive is created.

# How to fix problems with a Ubuntu Disk
After booting into Ubuntu using a disk or flashdrive
1. Try use Boot-Repair first
  * After booting into Ubuntu by choosing "Try Ubuntu", open a terminal, and type in
  ```
  sudo add-apt-repository ppa:yannubuntu/boot-repair && sudo apt-get update
  sudo apt-get install -y boot-repair && (boot-repair &)
  ```
  Use recommended setting to reinstall Grub2. If this gives an error or does not fix the problem after reboot, use the next method

2. Reinstalling Grub:
  * In the DashHome, start DiskUtility. Determine which partition or drive the OS is installed on
  * mount the parition
  ```
  sudo mount /dev/sdXY /mnt
  ```
  where for `sdXY`, `X` is the dirve of the OS, and `Y` is the parition onthe drive of the OS

  * Detect OS
  ```
  sudo mount --bind /dev /mnt/dev && sudo mount --bind /dev/pts /mnt/dev/pts && sudo mount --bind /proc /mnt/proc && sudo mount --bind /sys /mnt/sys
  ```
  * jump into the installed OS
  ```
  sudo chroot /mnt
  ```

  * install Grub (or any other problems you have that may prevent you from starting)
  ```
  sudo grub-install /dev/sdX #(note there is no Y)
  sudo grub-install --recheck /dev/sdX #(double checking)
  sudo update-grub
  ```

 * exit and unmount
 ```
 exit && sudo umount /mnt/dev && sudo umount /mnt/dev/pts && sudo umount /mnt/proc && sudo umount /mnt/sys && sudo umount /mntv
 ```

# Fix AMD Unsupported hardware watermark (may prevent booting)
1. Determine Graphics Card
```
lspci | grep VGA
```
2. Search for the Driver and install the driver
  * **If you are trying to fix a boot problem, do the following, as root**
  ```
  sudo cp /etc/X11/xorg.conf /etc/X11/xorg.conf.BAK
  sudo apt-get remove --purge fglrx fglrx-amdcccle
  sudo apt-get remove --purge fglrx-updates fglrx-amdcccle-updates
  cd /usr/share/ati
  ./fglrx-uninstall.sh --force
  ```
  to force install all the previous drivers

  * Install generic header (for 12.04 to 13.04, newer version of ubuntu)
  ```
  sudo apt-get install linux-headers-generic
  ```
  * Install the graphic driver
  ```
  sudo apt-get install fglrx fglrx-amdcccle
  ```
  * **MUST GENERATE** a fresh `xorg.conf` **BEFORE REBOOTING!**
  ```
  sudo aticonfig --initial  OR
  sudo amdconfig --initial
  ```
  If this is not found, try to
  ```
  cd /usr/lib/fglrx/bin
  ```
  * Install mesa-utils for Unbuntu to recognize the graphics card
  ```
  sudo apt-get install mesa-utils
  ```


# Changing ownership of a folder
```
sudo chown -R usr:group /path/to/folder
```

# Copying files
```
sudo rsync -rlc /source/directory /target/directory
```

Keep the name of the target folder the same as the source folder.

If the named folder does not exist, create one.

If the source is ended with '/', will be treated as a directory, otherwise, will be treated as an object, which will create a folder of the same name under `/target/directory`

`-r` recursively

`-l` copy symbolic links as symbolic links without conversion

`-c` do a loose checkum

`-v` if desired to monitor the progress

# How to set up git: https://help.github.com/articles/
1. Install git
```
sudo apt-get install git
```
2. Set profile
  * User name:
  Sets the default name for git to use when you commit
  ```
  git config --global user.name "Your Name here in the quote"
  ```
  * Email
  Sets the default email for git to use when you commit
  ```
  git config --global user.email "YourEmailHereInTheQuote@example.com"
  ```
3. Cache username and password temporarily so that it is not going to ask you for them every time
  Set git to use the credential memory cache
```
git config --global credential.helper cache
```
  If want to change the duration of cache
  Set the cache to timeout after 1 hour (setting is in seconds)
  ```
  git config --global credential.helper 'cache --timeout=3600'
  ```

4. Initialize
```
git init
```
5. Add files
```
git add FILENAME
```
OR
```
git add folder/*  #to add all files in a folder
```
To ignore removed files (no longer updating the deleted files)
```
git add -u
```
6. Make commitment
```
git commit -m "first commit" # commit the files with message "first commit"
```

7. Push the commit
```
git remote add origin https://github.com/username/repository_name.git
git push origin master
```
 *To force pushing*
```
git push -f origin master
```

8. Remove a duplicate directory
```
git rm -r /duplicated/directory
git commit -m "remove duplication"
git push origin master
```

9. Recover deleted files
If the files are deleted via
```
git rm -r /duplicated/directory
```
Do the following:
```
git reset --hard HEAD
```
OR if the file names are known
```
git checkout deleted_file
```
10. Clone a repository
```
git clone https://github.com/username/repository.git
```

11. Correct CRLF to LF
To convert all CRLF to LF
```
git config --global core.autocrlf true
```
To convert CRLF to LF on Lunix/Unix and repository, but keep CRLF on Windows
```
git config --global core.autocrlf input
```
To stop converting any CRLF to LF
```
git config --global core.autocrlf false
```


12. Set up github page
* Make a repository on github.com first. Name this repository exactly in the format username.github.io
* Make a local folder with the same name username.github.io
* Add files in this local folder. Must have a index.html file. This will be the main page of the website https://username.github.io
  - In the following example, let's create a index page to link to other files in the subfolders

  ```html
  <p>Notebook list</p>

  <p>* <a href="benefits/">Benefits</a></p> <!-- pointing to some subfolder-->
  <p>* <a href="factors/">Factors</a></p>
  <p>* <a href="society/">Society</a></p>
  <p>* <a href="scatters/">Scatters</a></p>
  ```
* Commit the added files
* Now it is ready to visit https://username.github.io/

# How to run a scheduled job
1. Install `crontab`
```
sudo apt-get install crontab
```

2. open the `crontab` job file scheduler
```
crontab -e
```

3. Schedule the backup

  *Schedule a backup at 20:00 every day8*
  ```
  00 20 * * * bash ./backuputil/backup_files_snapshots.sh
  ```

  *Schedule the backup at 20:00 every other day*
  ```
  00 20 1-31/2 * * bash ./backuputil/backup_files_snapshots.sh
  ```
  *Schedule the backup check every beginning of the month*
  ```
  @monthly bash ./backuputil/backup_diff_snapshots.sh
  ```

4. get a list of active jobs / list the content of `crontab`
```
crontab -l
```

5. Broken Pipe in MacOSX
Add the following lines
```
ServerAliveInterval 120
TCPKeepAlive no
```

to the file: `/etc/ssh_config`

# How to mount an external drive
```
sudo mount /dev/sda2 /nfs
```

# Run a process in the background, non-stop even at log off: `nohup`
1. To run bash script, simply
```
nohup bash_script.sh
```
2. To run other languages, e.g. Python
```
nohup python python_script.py
```
`nohup` will automatically create a file named `nohup.out` to collect screen prints

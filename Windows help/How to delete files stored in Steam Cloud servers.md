HOW TO DELETE FILES STORED IN STEAM CLOUD SERVERS

Context:
I've read many times on this forum topics with concerns about the fact that it's impossible to manage files stored in Steam Cloud servers. This can be very annoying if you want to know exactly what files are in the Cloud or to solve sync problems such as savegame overwriting. Since no good solution was available, I've decided to look at the issue and try to understand how Steam Cloud works.

Presentation of Steam Cloud:
Steam Cloud is used to backup config files and savegames online in order to access them from every computer. It's a feature that can be enabled/disabled through two different dialogs:
- Steam > Settings > Downloads + Cloud > Enable Steam Cloud synchronization for games which support it (will affect all the games)
- Right-click on a game > Properties > Updates > Enable Steam Cloud synchronization for GameName (will only affect the selected game)

How it works:
The first thing you should know is that there are most of the time three versions of your save files:
- the original version stored in the game folder or in AppData (S1)
- the cloud version stored in Steam\userdata\SteamID\AppID (S2)
- the cloud version stored in Steam servers (S3)
When you start a game for the first time, S1 is created. When you close it, S1 is copied to S2 which is then synced to S3.
When you start a game from another computer, if Steam has S3 on its servers but doesn't find S2 on your computer, it will copy S3 to S2. Steam Cloud automatically downloads the missing files each time you start Steam.
You understand that the most important save location for us is S2. If we play a bit with it, we should be able to reach our goal. So what's in S2?
Note: some games don't have S1 and write directly to S2, while others don't use the S2 remote folder to store the save files. In this case, the remotecache.vdf file in S2 points directly to the files located in S1 (thanks TheOdds for the detail).

Userdata contents:
In Steam\userdata you should have 1 (or more) folder corresponding to your account ID (SteamID). Open it and you'll find a folder for each game using Steam Cloud you have installed. The folder name is the AppID of the game (found in the URL when you visit its store page, it's a number like 220 for Half-Life 2). In the game folder you'll found:
- a remote folder: it contains all the files that are being synced up with Steam servers
- a remotecache.vdf file: the file describe the properties (such as file size or modification date) of the files contained in the remote folder

In this tutorial there are 2 main steps:
I. Bringing up the Cloud Sync Conflict dialog
II. Deleting the Cloud files
Note that you have to repeat these steps for EVERY game you want to delete Steam Cloud files!

But first I would like you to delete your AppID folder and restart Steam: you'll see that it will automatically recreate the AppID folder and download the missing files from Steam Cloud. This verification is important for you to make sure that the whole operation has been successful.

After this long but necessary introduction, let the magic begin!

I. Bringing up the Cloud Sync Conflict dialog

The first part is probably the most difficult. In order to get rid of the files stored in Steam servers, we'll need the help of the Cloud Sync Conflict dialog. It appears when the Cloud files differ from the local files stored on your computer. There are several ways to get it, I'll give you two:

1) Exit Steam and make sure that Steam Cloud is enabled.
2) Alter the content of all files in Steam\userdata\SteamID\AppID\remote. The objective is that every file becomes different from the ones stored in the Cloud. You can't simply delete the files otherwise Steam will download them from the Cloud. You can corrupt them by deleting all their content. 0 bytes files will indeed do the trick. To do this (thanks Kevin92 for the tip):
- Hold Shift and right-click on your remote folder.
- Click on "Open command window here".
- Enter powershell.
- Enter clc C:\Steam\userdata\SteamID\AppID\remote\* (clc + absolute path of your remote folder + * to affect all the files).
- Done: all your files are now 0 bytes!
Warning: be sure of the path your enter to not delete accidentally system or user files! There are not any confirmation when you press Enter!
3) Delete remotecache.vdf in Steam\userdata\SteamID\AppID.
4) Start Steam and "Sync conflict" should appear in your game status.

A simpler way but not as efficient:
1) Start Steam.
2) Disable Steam Cloud.
3) Delete all files in Steam\userdata\SteamID\AppID.
4) Start the game to create fresh (and thus different) new files.
5) Exit the game and Steam.
6) Delete remotecache.vdf in Steam\userdata\SteamID\AppID.
7) Start Steam.
8) Enable Steam Cloud and "Sync conflict" should appear in your game status.
Note that this method may not affect all the files (and you need to modify all of them if you want to delete all of them later).

Once you have "Sync conflict", start your game and the Cloud Sync Conflict dialog should appear.

II. Deleting the Cloud files

Ok now it's piece of cake. Once the dialog is opened, don't click on any option.
1) Go to Steam\userdata\SteamID\AppID and delete ALL the files in it, remote folder and remotecache.vdf.
2) Go back to the Cloud Sync Conflict dialog and click on "Upload to the Steam Cloud". Steam will sync your AppID folder with nothing in it... meaning that all the files on the Cloud will be deleted! You don't believe me? Wait for it, the demonstration is right after
3) Then the game should start automatically. But... it will create new files that will be synced when I'll leave the game!! Indeed it will, except if you...
4) Alt-tab the game and disable Steam Cloud.
5) Return to the game and exit it (or kill it through process manager). No files will be synced up!
6) Exit Steam.
7) Delete the AppID folder.

Note: if you haven't modified all the files in step I, only the modified ones will be deleted. The others will remain in Steam Cloud.

How to make sure it worked?

Remember at the beginning when I told you to delete your AppID folder to see that Steam Cloud automatically download the missing files each time you start Steam? Normally, if there is no file left in Steam Cloud, it won't download anything on your computer. So here is how to check it:
1) Enable Steam Cloud.
2) Exit Steam.
3) Delete the AppID folder (if you didn't do it in step II).
4) Start Steam. Steam will now check S3 (Cloud files) and compare them with S2 (local files). Nothing in S3? Nothing copied to S2!
5) Check your Steam\userdata\SteamID folder. No new AppID folder has been created!
You can eventually check on another computer and see that no files are downloaded anymore from Steam Cloud.

Congratulations, you have successfully deleted your files from Steam Cloud

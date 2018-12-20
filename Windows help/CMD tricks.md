# Windows Command Prompt tricks

ref: [10 Cool Command Prompt Tricks You Should Know](https://www.youtube.com/watch?v=TdWPEN_57mI)

1. Encrypt a single folder
`cd` into the folder, then
```
Cipher /E
```

2. Change the color of the text of CMD
`help color` to view the list of colors
```
color 02
```
will change the text to green.

3. Change prompt text.

By default, the prompt text is the current path.
```
C:\Users\
```
The following command
```
prompt akshay@beebom$G
```
will change the prompt to
```
akshay@beebom>
```
With `help prompt`, we know that `$G` is the greater than sign `>`

4. Change window title
```
title Death Star Console
```
change the title of the CMD window

5. Watch Star Wars in ASCII text
```
telnet towel.blinkenlights.nl
```

6. Wifi Hotspot

```
netsh wlan set hostednetwork mode=allow ssid=HotspotName key=Password
```

where `HotspotName` is the custom Wifi hotspot network name, and `Password` is the designated password used to log into the Wifi hotspot network. To turn it on,

```
netsh wlan start hostednetwork
```
To turn it off,

```
netsh wlan stop hostednetwork
```

7. Hide Folders
This will hide the folder completely, meaning even if `Show hidden folders` option is checked in the `Control Pane --> Folder options`
`cd` to that directory to be hidden, then type,
```
Attrib +h +s +r
```

To show this folder again, type
```
Attrib -h -s -r
```

8. Copy CMD output to a clipboard
Useful for long outputs
```
ipconfig | clip
```
The output of `ipconfig` is copied to the clipboard

9. List all the installed programs
```
wmic product get name
```
To uninstall a program
```
wmic product where "name like '%NAMEOFAPP%'" call uninstall /nointeractive
```

For example,
```
wmic product where "name like iTunes" call uninstall /nointeractive
```
will uninstall `iTunes`.

10. Open CMD Window in directory
In the address bar of the `explorer`, type in `cmd`. The CMD console will launch in that directory of the `explorer`

11. Command history
Press `F7` to see the list of command used in that session.

12. Spin up the GUI for changing the Environment variables
Run --> `control sysdm.cpl`

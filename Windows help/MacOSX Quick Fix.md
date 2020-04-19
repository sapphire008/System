# MacOSX  Quick Fix

## No Wifi connection after connecting to external monitor via mini display / thunderbolt port

Thunderbolt port is multi-purpose. Probably the computer was preferentially recognizing it as an ethernet connection. Turn off the Ethernet connection may help. To do so, go to System Prefrences --> Network --> Thunderbolt Bridge --(click on cog icon in the bottom of the list) --> Make Service Inactive.

## My iPhone keeps switching on and off charge whilst charging, how do I fix it?

`sudo killall -STOP -c usbd`

To revert

`sudo killall -CONT usbd`

# Laptop brightness problems

My ancient Thinkpad W510 monitor brightness control failed to work, even though the on-screen popup indicated that the monitor brightness was changing. After reading many web articles, changing many files, and rebooting, I eventually discovered this article about [LCD Brightness](http://www.thinkwiki.org/wiki/LCD_Brightness), which pointed me towards adding this file:

/usr/share/X11/xorg.conf.d/20-nvidia.conf
````
Section "Device"
  Identifier "NVIDIA"
  Driver "nvidia"
  Option  "NoLogo" "True"
  Option "RegistryDwords" "EnableBrightnessControl=1"
EndSection
````

Various articles which suggested changing these files did not work

- NOPE: /etc/default/grub
- NOPE: /etc/modprobe.conf


# -> external monitor not working with Thinkpad Brightness control; maybe try this again:

https://www.pcsuggest.com/adjust-linux-screen-brightness/
# Computer always boots into Windows instead of showing boot menu

## Verify that ubuntu boot path exists

https://superuser.com/questions/662823/how-do-i-mount-the-efi-partition-on-windows-8-1-so-that-it-is-readable-and-write

Use the `Disk Management` tool to discover the disk/partition for the commands below

````
diskpart
list disk
select disk 0
list partition
select partition 1
assign letter=b
exit
````

From an elevated shell:

````
ls /b/EFI/ubuntu/grubx64.efi
````

## Change to grub boot

https://itsfoss.com/no-grub-windows-linux

From an elevated command-prompt
````
# Save old settings
bcdedit > patw-save-bcd-settings.txt
bcdedit /set {bootmgr} path \EFI\ubuntu\grubx64.efi
````

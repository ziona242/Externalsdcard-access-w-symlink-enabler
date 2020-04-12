###### UPGRADED MAGISK VERSION #######

# External Sd write access with symlink system in rootfs & mnt folder.

## Android versions supported !!

# Marshmallow    ⭕
# Nougat         ⭕
# Oreo           ⭕
# Pie            ⚠ (not fully supported yet, may not work needs testing by users. still [WIP])
# Q              📵


-System remounted RW
-Provides full Permissive mode -Optional
-Provides Invert back Selinux Enforcing mode -Optional
-Sepolicy internal & external sdcard Platform.xml patch for rw permissions to system files & directories on some devices
-Provides app backup access write permissions an quicker access to external_sd mounted in root dir.
-Example.. titanium backup can use external sdcard link in root folder or /mnt/sdcard1 to store backup files..
-Custom Magisk installer 
-Custom modded busybox -Optional
-Custom Ext.sdcard dual mounts -Optional
-Can be used alone with only write sdcard access installed systemless
-Stock files backup before systemless altering (patching) of files ... - Safetynet (.bak file creation of original)

# Credits
-Ziona @xda developers

# Thanks to ;
-@Rom also for their work on ext-sd write access enabler first ...... @Xda developers.  
-@Aaron Kling for late Oreo + sepolicy patch ...... @Github.
-They give me some ideas go further with this.. 

# My Thread;
https://forum.xda-developers.com/android/general/mods-external-sdcard-linker-write-t4078731


# After first beta version 4

# Change log: v4.1
added sepolicy patch - Android version - Optional install
added new latest magisk install template with selection.
added permissive mode - Optional install
added busybox modded app2sd version -Optional install
added sdmount for symlinks - Optional install 
added external Sd write access enabler' Standalone mode - if no options selected on install..
script - adjustments in post-fs-data.sh for file backups, file sed an patching.
script - adjustments in sdmount.sh for better mounting & optimized bootcomplete start execution for creating symlinks & automatic file deletion on magisk module removal.

# Module build date;
  11/04/2020  
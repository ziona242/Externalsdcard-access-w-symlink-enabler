#!/system/bin/sh
# Team Ziona Mods @xda developers

# Mount all & sdcard
busybox mount -o remount,rw / 2>/dev/null
busybox mount -o remount,rw /system 2>/dev/null
busybox mount -t vfat -o rw,dirsync,nosuid,nodev,noexec,relatime,uid=1000,g id=1015,fmask=0702,dmask=0702,allow_utime=0020 /dev/block/mmcblk1p1 /sdcard/emmc 2>/dev/null  

# Main Module check for uninstalled or disabled
if [ ! -d /data/adb/modules/ExternalSDCard ]; then
rm -f /data/adb/service.d/sdmount.sh
echo "deleting!"
exit
elif [ ! -e /data/adb/modules/ExternalSDCard/disable ]; then
echo "enabled!"
else
echo "disabled!"
exit
fi;

# Set Permissive
#setenforce 0

# External sdcard dual symlink system
function sdcard_link() {
# Sdcard set link 1
SERIAL=`ls /mnt/media_rw/ | head -n 1`
FULL_PATH="/mnt/media_rw/$SERIAL"
SERIAL_LENGTH=${#SERIAL}
LINK_NAME="external_sd"
SERIAL_1=`ls /storage/ | head -n 1`
FULL_PATH_1="/storage/$SERIAL_1"
LINK_NAME_1="external_sd"
if [ -d $LINK_NAME ] ; then
    echo "Link already enabled!"
elif [[ $SERIAL_LENGTH -lt 1 ]] ; then
    echo "Wrongy formed path!"
    echo "link-1 *storage* using method 2!"
    mount -o rw,remount /
    ln -sf $FULL_PATH_1 $LINK_NAME_1 
elif [ ! -d "$FULL_PATH" ] ; then
    echo "link-1 *storage* using method 2!"
    mount -o rw,remount /
    ln -sf $FULL_PATH_1 $LINK_NAME_1 
else
    echo "link-1 *media_rw* using method 1!"
    mount -o rw,remount /
    ln -sf $FULL_PATH $LINK_NAME 
fi;
# Sdcard set link 2
FULL_PATH_2="/mnt/media_rw/$SERIAL_2"
SERIAL_2=`ls /mnt/media_rw/ | head -n 1`
SERIAL_LENGTH_2=${#SERIAL_2}
LINK_NAME_2="mnt/sdcard1"
SERIAL_3=`ls /storage/ | head -n 1`
FULL_PATH_3="/storage/$SERIAL_3"
LINK_NAME_3="mnt/sdcard1"
if [ -d $LINK_NAME_2 ] ; then
    echo "Link already enabled!"
elif [[ $SERIAL_LENGTH_2 -lt 1 ]] ; then
    echo "Wrongly formed path!"
    echo "link-2 *storage* using method 2!"
    mount -o rw,remount /
    ln -sf $FULL_PATH_3 $LINK_NAME_3 
elif [ ! -d "$FULL_PATH_2" ] ; then
    echo "link-2 *storage* using method 2!"
    mount -o rw,remount /
    ln -sf $FULL_PATH_3 $LINK_NAME_3 
else
    echo "link-2 *media_rw* using method 1!"
    mount -o rw,remount /
    ln -sf $FULL_PATH_2 $LINK_NAME_2 
fi;
}

(while true; do sleep 1
    if [ `getprop sys.boot_completed` -eq 1 ] || [ `getprop init.svc.bootanim` = "stopped" ]; then sleep 10
       if [ `ls /storage/ | head -n 1` ] || [ `ls /mnt/media_rw/ | head -n 1` ]; then sleep 5
           sdcard_link;
       fi;
     break
   fi;
done)&

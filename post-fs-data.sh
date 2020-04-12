#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in post-fs-data mode
# Team Ziona Mods @xda developers
mount -o rw,remount /
mount -o rw,remount /data
mount -o rw,remount /system
# Additional VARs
COMMONFILES=$MODDIR/common/
BUILDPROP=/system/build.prop
SYSLESSBUILDPROP=$MODDIR/system/build.prop
PHONEID=`grep_prop ro.build.product $BUILDPROP`
ANDROVERSION=`grep_prop ro.build.version.release $BUILDPROP`
PERMISSIONS=$MODDIR/system/etc/permissions/
PLATFORMFILE=/system/etc/permissions/platform.xml
SERVICEMODPATH=/data/adb/service.d/*
chmod 777 $SERVICEMODPATH
cp -af $PLATFORMFILE /system/etc/permissions/platform.bak
mkdir -p $PERMISSION
cp -af -r $PLATFORMFILE $PERMISSIONS
if grep -qs '<group gid="sdcard_all" />' $PERMISSIONS/platform.xml
then
echo "write access already enabled"
elif grep -qs '<group gid="sdcard_rw" />' $PERMISSIONS/platform.xml
then
sed -i -e '\:\<group gid="sdcard_rw" />:a\        <group gid="sdcard_all" />' $PERMISSIONS/platform.xml
echo "write access started"
elif grep -qs '<group gid="media_rw" />' $PERMISSIONS/platform.xml
then
sed -i -e '\:\<group gid="media_rw" />:a\        <group gid="sdcard_rw" />' $PERMISSIONS/platform.xml
sed -i -e '\:\<group gid="sdcard_rw" />:a\        <group gid="sdcard_all" />' $PERMISSIONS/platform.xml
echo "write access started done"
fi;
if grep -qs '<permission name="android.permission.READ_EXTERNAL_STORAGE" />' $PERMISSIONS/platform.xml
then
echo "read storage enabled"
else
sed -i -e '36i\    <permission name="android.permission.READ_EXTERNAL_STORAGE" />' $PERMISSIONS/platform.xml
echo "read S added"
fi;
if grep -qs '<permission name="android.permission.WRITE_EXTERNAL_STORAGE" />' $PERMISSIONS/platform.xml
then
echo "write storage enabled"
else
sed -i -e '\:\<permission name="android.permission.READ_EXTERNAL_STORAGE" />:a\    <permission name="android.permission.WRITE_EXTERNAL_STORAGE" />' $PERMISSIONS/platform.xml
echo "write S added"
fi;
if grep -qs '<group gid="sdcard_r" />' $PLATFORMFILE
then
echo "sdcard RW access"
else
sed -i -e '\:\<permission name="android.permission.WRITE_EXTERNAL_STORAGE" />:a\        <group gid="media_rw" />' $PERMISSIONS/platform.xml
sed -i -e '\:\<permission name="android.permission.WRITE_EXTERNAL_STORAGE" />:a\        <group gid="sdcard_rw" />' $PERMISSIONS/platform.xml
sed -i -e '\:\<permission name="android.permission.WRITE_EXTERNAL_STORAGE" />:a\        <group gid="sdcard_r" />' $PERMISSIONS/platform.xml
fi;
chmod -R 644 $PERMISSIONS/platform.xml

cp -af $BUILDPROP /system/build.prop.bak
cp -af -r $BUILDPROP $SYSLESSBUILDPROP
if grep -qs 'ro.sys.sdcardfs=true' $SYSLESSBUILDPROP; then
sed -i '/ro.sys.sdcardfs=true/c ro.sys.sdcardfs=false' $SYSLESSBUILDPROP
fi;
if grep -qs 'persist.esdfs_sdcard=true' $SYSLESSBUILDPROP; then
sed -i '/persist.esdfs_sdcard=true/c persist.esdfs_sdcard=false' $SYSLESSBUILDPROP
fi;
if grep -qs 'persist.sys.sdcardfs=true' $SYSLESSBUILDPROP; then
sed -i '/persist.sys.sdcardfs=true/c persist.sys.sdcardfs=false' $SYSLESSBUILDPROP
fi;
if grep -qs 'persist.fuse_sdcard=false' $SYSLESSBUILDPROP; then
sed -i '/persist.fuse_sdcard=false/c persist.fuse_sdcard=true' $SYSLESSBUILDPROP
fi;
if grep -qs 'persist.fuse_sdcard=true' $SYSLESSBUILDPROP; then
echo "already fused sdcard"
else
echo "" >> ${SYSLESSBUILDPROP}
echo "persist.fuse_sdcard=true" >> ${SYSLESSBUILDPROP}
fi;
if grep -qs 'persist.sys.sdcardfs=force_off' $SYSLESSBUILDPROP; then
echo "sdcard force off"
else
echo "" >> ${SYSLESSBUILDPROP}
echo "persist.sys.sdcardfs=force_off" >> ${SYSLESSBUILDPROP}
fi;
OPERMISSIONS=/system/etc/O-permissions
EXOREOAPP=/ExSDCard_Oreo_apps
EXOREOAPPBAK=/ExSDCard_Oreo_apps.bak
if [ -a "$EXOREOAPP" ]; then
	cp $EXOREOAPP $EXOREOAPPBAK
	NEW=$(awk '{ print }' $EXOREOAPPBAK)
	mkdir $OPERMISSIONS
	printf '<?xml version="1.0" encoding="utf-8"?>\n<permissions>\n  <privapp-permissions package="com.package.name">\n	<permission name="android.permission.DUMP" />\n	<permission name="android.permission.READ_LOGS" />\n	<permission name="android.permission.DEVICE_POWER" />\n  </privapp-permissions>\n</permissions>\n' >> /privapp-permissions-com.package.name.xml
	printf '%s\n' "$NEW" | while IFS= read -r line
	do sed "s/com.package.name/$line/" < /privapp-permissions-com.package.name.xml >  $OPERMISSIONS/privapp-permissions-$line.xml
	cp -n $OPERMISSIONS/*.xml /system/etc/permissions/
	rm -rf $OPERMISSIONS/*
	rm -f $EXOREOAPPBAK
	chmod -R 644 /system/etc/permissions/*
done
fi;
	
# uninstall.sh
#mv -f $MODPATH/common/uninstall.sh $MODPATH/uninstall.sh

if [ `cat /sys/fs/selinux/enforce` -eq 0 ]; then
echo "permissive mode"
else
setenforce <SOURCE>
adb shell setenforce <SOURCE>
fi; 
exit 0

#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# write to uninstall.sh if present in module else let sdmount delete itself when ever
sed -i -e '6i\FILE=/data/adb/service.d/sdmount.sh' /data/adb/modules/ExternalSDCard/uninstall.sh
sed -i -e '23i\ rm -f $FILE' /data/adb/modules/ExternalSDCard/uninstall.sh

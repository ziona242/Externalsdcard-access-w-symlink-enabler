filedir=$MODPATH/file
modprop=$MODPATH/module.prop
sepolicy=$MODPATH/
permiss=0
enforce=1


# Selections
m() { cp $filedir/m/sepolicy.rule $sepolicy; }
n() { cp $filedir/n/sepolicy.rule $sepolicy; }
o() { cp $filedir/o/sepolicy.rule $sepolicy; }
p() { cp $filedir/p/sepolicy.rule $sepolicy; }
x() { ui_print "- Selinux options not used !"; }
q() { abort "- Android Q not supported !"; }
r() { ui_print "- Permissive Mode !"; sed -i "s/<SOURCE>/$permiss/g" $MODPATH/post-fs-data.sh; cp $filedir/system.prop $sepolicy; }
e() { ui_print "- Enforcing Mode !"; sed -i "s/<SOURCE>/$enforce/g" $MODPATH/post-fs-data.sh; }
busybox() { ui_print "- Modded Busybox !"; cp_ch $filedir/busybox $MODPATH/system/bin/; sed -ie 3's/$/-Busybox&/' $modprop; }
sdmount() { ui_print "- Sdcard Symlinks !"; cp_ch $filedir/sdmount.sh $MODDIR/data/adb/service.d/; sed -ie 3's/$/-SDlink&/' $modprop; }

cleanup() {
  rm -rf $filedir
}

# Android version selection;
PART=1
ui_print "            ********************* "
ui_print "            *     Ziona Mods    *"
ui_print "            *                   *"
ui_print "            *********************"           
ui_print "    *  Please press vol buttons twice  * "
ui_print "              for some devices "
ui_print "  "
ui_print "-       *  Install Custom Sepolicy?  * "
ui_print "-         Select (version #) if Yes "
ui_print "  "
ui_print "- Run Permissive instead of Custom Sepolicy? "
ui_print "- Restore Enforcing if Permissive was used?  "
ui_print "  "
ui_print "- Which Android version are you using?"
ui_print "-     Vol(+) = Next | Vol(-) = Select"
ui_print "  "
ui_print "-  1. Q (10) not supported"
ui_print "-  2. Pie (9) may not work"
ui_print "-  3. Oreo (8.0/8.1)"
ui_print "-  4. Nougat (7.0/7.1)"
ui_print "-  5. Marshmallow (6.0/6.0.1)"
ui_print "-  6. Permissive Mode "
ui_print "-  7. Enforcing Mode "
ui_print "-  8. Dont use any  "
ui_print " "
ui_print "      Select:"
while true; do
	ui_print "  $PART"
	if $VKSEL; then
		PART=$((PART + 1))
	else 
		break
	fi
	if [ $PART -gt 8 ]; then
		PART=1
	fi
done
ui_print "  Selected: $PART"

BUSYBOX=false
if [ $PART -ne 0 ]; then
ui_print "   "
ui_print "- Do you want modded busybox with this?"
ui_print "-      Vol(+) = Yes | Vol(-) = No"
ui_print "   "
	if $VKSEL; then
	BUSYBOX=true	
	ui_print "   Selected: Yes (Good)"
	else
	ui_print "   Selected: No"	
	fi
fi
ui_print "        Next "

SDMOUNT=false
if [ $PART -ne 0 ]; then
ui_print "   "
ui_print "-   Recommended for sdcard links! "
ui_print "   "
ui_print "- Create external-SD dual symlinks? "
ui_print "-   Vol(+) = Yes | Vol(-) = No"
ui_print "   "
	if $VKSEL; then
	SDMOUNT=true	
	ui_print "  Selected: Yes"
	else
	ui_print "  Selected: No"	
	fi
fi
# Installation;
ui_print "- Almost Finished"
ui_print "- Installing"

case $PART in
	1 ) q; sed -ie 3's/$/-Q&/' $modprop;;
	2 ) p; sed -ie 3's/$/-Pie&/' $modprop;;
	3 ) o; sed -ie 3's/$/-Oreo&/' $modprop;;
	4 ) n; sed -ie 3's/$/-Nougat&/' $modprop;;
	5 ) m; sed -ie 3's/$/-Marshmallow&/' $modprop;;
    6 ) r; sed -ie 3's/$/-Permissive&/' $modprop;;
    7 ) e; sed -ie 3's/$/-Enforcing&/' $modprop;;
    8 ) x; sed -ie 3's/$/-Unpatched&/' $modprop;;
esac

if $BUSYBOX; then
	busybox
fi

if $SDMOUNT; then
	sdmount
fi

$cleanup


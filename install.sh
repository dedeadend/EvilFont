##################################
# Magisk Module Installer Script #
##################################

SKIPMOUNT=false

PROPFILE=false

POSTFSDATA=false

LATESTARTSERVICE=false

print_modname() {
    ui_print "                               "
    ui_print "_______________________________"
    ui_print "                               "
    ui_print "       E v i l   F o n t       "  
    ui_print "_______________________________"
    ui_print "                               "
}

on_install() {
    ui_print "                               "
    ui_print "-------------------------------"
    ui_print "                               "
    ui_print "  - Extracting module files    "
    ui_print "                               "
    ui_print "  - Adding Fonts ...           "
    ui_print "                               "
    ui_print "  [NOTE] Don't Hide Google     "
    ui_print "  Apps from Magisk To work the "
    ui_print "  Module in Google System Apps "
    ui_print "                               "
    ui_print "  Created by : DeDeadend       "
    ui_print "                               "
    ui_print "-------------------------------"
    ui_print "                               "
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
}

set_permissions() {
  set_perm_recursive $MODPATH 0 0 0755 0644
}

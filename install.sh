#!/system/bin/sh
##################################
# EvilFont - Interactive Install #
##################################

SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=false

print_modname() {
    ui_print " "
    ui_print "  ______          _"
    ui_print " |  ____|    (_) | |"
    ui_print " | |__ __   _| | | |"
    ui_print " |  __|\ \ / / | | |"
    ui_print " | |___ \ V /| | | |__"
    ui_print " |______|\_/ |_| |____|"
    ui_print " "
    ui_print "  ______          _"
    ui_print " |  ____|        | |"
    ui_print " | |__ ___  _ __ | |_"
    ui_print " |  __/ _ \| '_ \| __|"
    ui_print " | | | (_) | | | | |_"
    ui_print " |_|  \___/|_| |_|\__|"
    ui_print " "
    ui_print " "
    ui_print " Developed by DeDeadend"
    ui_print "      version 2.0"
    ui_print " "
    ui_print " "
}

FONTS="Vazirmatn(Recommended) Baloo_Bhaijaan_2 Beiruti El_Messiri Estedad Harmattan IBM_Plex_Sans_Arabic Markazi_Text Noto_Sans_Arabic Parastoo Playpen_Sans_Arabic Reem_Kufi Tajawal Vazirmatn_Round_Dots Zain"
TOTAL_FONTS=15

EMOJI_VERSIONS="iOS_18.4(Recommended) macOS_26(Experimental)"
TOTAL_EMOJI=2

get_key() {
    while true; do
        EVENT=$(getevent -qlc 1 2>/dev/null)
        if [ -n "$EVENT" ]; then
            LAST_WORD=$(echo "$EVENT" | awk '{print $NF}')
            if [ "$LAST_WORD" = "DOWN" ]; then
                if echo "$EVENT" | grep -q "KEY_VOLUMEUP"; then
                    echo "UP"
                    return
                elif echo "$EVENT" | grep -q "KEY_VOLUMEDOWN"; then
                    echo "DOWN"
                    return
                fi
            fi
        fi
        sleep 0.05
    done
}

select_yes_no() {
    TITLE="$1"
    CURRENT=0
    
    while true; do
        ui_print " "
        ui_print "━━━━━━━━━━━━━━━━━━━━━━"
        ui_print "  $TITLE"
        ui_print "━━━━━━━━━━━━━━━━━━━━━━"
        ui_print "  Vol-: Toggle  |  Vol+: Select"
        ui_print " "
        
        if [ "$CURRENT" = "0" ]; then
            ui_print "  ➤ ✔️ Yes"
            ui_print "    ✖️ No"
        else
            ui_print "    ✔️ Yes"
            ui_print "  ➤ ✖️ No"
        fi
        
        KEY=$(get_key)
        
        if [ "$KEY" = "DOWN" ]; then
            CURRENT=$(( (CURRENT + 1) % 2 ))
        elif [ "$KEY" = "UP" ]; then
            return $CURRENT
        fi
    done
}

select_font() {
    CURRENT=0
    
    while true; do
        ui_print " "
        ui_print "━━━━━━━━━━━━━━━━━━━━━━"
        ui_print "  Choose Font"
        ui_print "━━━━━━━━━━━━━━━━━━━━━━"
        ui_print "  Vol-: Next  |  Vol+: Select"
        ui_print " "
        
        INDEX=0
        for F in $FONTS; do
            if [ "$INDEX" -eq "$CURRENT" ]; then
                ui_print "  ➤ $F"
            else
                ui_print "    $F"
            fi
            INDEX=$((INDEX + 1))
        done
        
        KEY=$(get_key)
        
        if [ "$KEY" = "DOWN" ]; then
            CURRENT=$(( (CURRENT + 1) % TOTAL_FONTS ))
        elif [ "$KEY" = "UP" ]; then
            SELECTED_INDEX=$((CURRENT + 1))
            SELECTED_FONT=$(echo $FONTS | cut -d' ' -f$SELECTED_INDEX)
            return 0
        fi
    done
}

select_emoji_version() {
    CURRENT=0
    
    while true; do
        ui_print " "
        ui_print "━━━━━━━━━━━━━━━━━━━━━━"
        ui_print "  Choose Emoji Version"
        ui_print "━━━━━━━━━━━━━━━━━━━━━━"
        ui_print "  Vol-: Next  |  Vol+: Select"
        ui_print " "
        
        INDEX=0
        for E in $EMOJI_VERSIONS; do
            if [ "$INDEX" -eq "$CURRENT" ]; then
                ui_print "  ➤ Apple $E"
            else
                ui_print "    Apple $E"
            fi
            INDEX=$((INDEX + 1))
        done
        
        KEY=$(get_key)
        
        if [ "$KEY" = "DOWN" ]; then
            CURRENT=$(( (CURRENT + 1) % TOTAL_EMOJI ))
        elif [ "$KEY" = "UP" ]; then
            SELECTED_INDEX=$((CURRENT + 1))
            SELECTED_EMOJI=$(echo $EMOJI_VERSIONS | cut -d' ' -f$SELECTED_INDEX)
            return 0
        fi
    done
}

on_install() {
    ui_print " "
    ui_print " ── Extracting resources..."
    unzip -o "$ZIPFILE" 'fonts/*' -d "$MODPATH" >&2
    unzip -o "$ZIPFILE" 'emojis/*' -d "$MODPATH" >&2
    
    mkdir -p "$MODPATH/system/fonts"

    select_yes_no "Install Custom Font?"
    INSTALL_FONT=$?

    if [ "$INSTALL_FONT" = "0" ]; then
        select_font
        
        ui_print " "
        ui_print " ── Installing: $SELECTED_FONT Font"
        
        if [ -d "$MODPATH/fonts/$SELECTED_FONT" ]; then
            cp -f "$MODPATH/fonts/$SELECTED_FONT"/* "$MODPATH/system/fonts/"
            ui_print " ✔️ Font installed successfully"
        else
            ui_print " ✖️ Font folder not found!"
            SELECTED_FONT="Stock"
        fi
    else
        SELECTED_FONT="Stock"
        ui_print " "
        ui_print " ✖️ Skipped font installation"
    fi

    select_yes_no "Install Apple Emoji?"
    INSTALL_EMOJI=$?

    if [ "$INSTALL_EMOJI" = "0" ]; then
        select_emoji_version
        
        ui_print " "
        ui_print " ── Installing: $SELECTED_EMOJI Emoji"
        
        if [ -f "$MODPATH/emojis/$SELECTED_EMOJI/NotoColorEmoji.ttf" ]; then
            cp -f "$MODPATH/emojis/$SELECTED_EMOJI/NotoColorEmoji.ttf" "$MODPATH/system/fonts/"
            echo "ON" > "$MODPATH/emoji_status.conf"
            ui_print " ✔️ Emoji installed successfully"
            EMOJI_STATUS="Apple $SELECTED_EMOJI"
        else
            ui_print " ✖️ Emoji file not found!"
            EMOJI_STATUS="Stock"
        fi
    else
        EMOJI_STATUS="Stock"
        echo "OFF" > "$MODPATH/emoji_status.conf"
        ui_print " "
        ui_print " ✖️ Skipped Apple Emoji"
    fi

    ui_print " "
    ui_print "━━━━━━━━━━━━━━━━━━━━━━"
    ui_print "  Installation Complete"
    ui_print "━━━━━━━━━━━━━━━━━━━━━━"
    ui_print " "
    ui_print "  Font : $SELECTED_FONT"
    if [ "$EMOJI_STATUS" != "Stock" ]; then
        ui_print "  Emoji: Apple $SELECTED_EMOJI"
    else
        ui_print "  Emoji: Stock"
    fi
    ui_print " "
    ui_print "  🔄 Reboot to apply"
    ui_print " "
}

set_permissions() {
    set_perm_recursive "$MODPATH" 0 0 0755 0644
}
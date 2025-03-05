#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt

[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"

get_controls

GAMEDIR=/$directory/ports/openmohaa
CONFDIR="$GAMEDIR/conf/"
#BINARY=launch_openmohaa_base.arm64
BINARY=launch_openmohaa_breakthrough.arm64
#BINARY=launch_openmohaa_spearhead.arm64

mkdir -p "$GAMEDIR/conf"

cd $GAMEDIR

> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1

bind_directories ~/.openmohaa $GAMEDIR/conf

export PATCHER_FILE="$GAMEDIR/tools/patchscript"
export PATCHER_TIME="5-10 minutes"

if [ ! -d "$GAMEDIR/main" ]; then
    if [ -f "$controlfolder/utils/patcher.txt" ]; then
        $ESUDO chmod a+x "$GAMEDIR/tools/patchscript"
        source "$controlfolder/utils/patcher.txt"
        $ESUDO kill -9 $(pidof gptokeyb)
    else
        echo "This port requires the latest version of PortMaster." > $CUR_TTY
    fi
else
    echo "Extraction process already completed. Skipping."
fi

# if successful, delete gog files?

export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"

if [ -f "${controlfolder}/libgl_${CFW_NAME}.txt" ]; then
  source "${controlfolder}/libgl_${CFW_NAME}.txt"
else
  source "${controlfolder}/libgl_default.txt"
fi

# delete unneeded files
rm "$GAMEDIR"/*.dll "$GAMEDIR"/*.exe

if [ "$LIBGL_FB" != "" ]; then
export SDL_VIDEO_GL_DRIVER="$GAMEDIR/gl4es.aarch64/libGL.so.1"
export SDL_VIDEO_EGL_DRIVER="$GAMEDIR/gl4es.aarch64/libEGL.so.1"
fi

# Use fullscreen mode on rocknix, otherwise the display is small
# On other CFWs, use windowed mode (otherwise crash on ArkOS)
if [ "$CFW_NAME" == ROCKNIX ] ; then
  FULLSCREEN=1
else
  FULLSCREEN=0
fi
sed -i -E "s/.*r_fullscreen.*/set r_fullscreen \"$FULLSCREEN\"/" \
  "$GAMEDIR"/conf/main*/configs/omconfig.cfg

# Calculate deadzone_scale based on DISPLAY_WIDTH
value=$((4*DISPLAY_WIDTH/480))
echo "Setting deadzone_scale to $value"
sed -i -E "s/(deadzone_scale) = .*/\1 = $value/g" \
  "$GAMEDIR/openmohaa.ini"

$GPTOKEYB2 "openmohaa.arm64" -c "./openmohaa.ini" &

pm_platform_helper "$GAMEDIR/$BINARY"

./$BINARY --verbose

pm_finish

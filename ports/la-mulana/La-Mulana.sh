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

export PORT_32BIT="Y"

[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"

get_controls

BINARY="LaMulana.bin.x86"
GAMEDIR="/$directory/ports/la-mulana"
CONFDIR="$GAMEDIR/conf/"

> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1

cd $GAMEDIR

# Extract gog installer if possible/needed
if [ ! -f "$GAMEDIR/game/$BINARY" ]; then
  # binary not present, attempt to extract
  EXTRACT_DIR="$GAMEDIR/extract"
  python3 "$GAMEDIR/tools/gogextract.py" \
    "$GAMEDIR/gamedata/"gog_la_mulana_*.sh "$EXTRACT_DIR"
  unzip "$GAMEDIR/extract/data.zip" -d "$EXTRACT_DIR"
  mv "$EXTRACT_DIR/data/noarch/game" "$GAMEDIR"

  rm -r "$GAMEDIR/extract"

  if [ -f "$GAMEDIR/game/$BINARY" ]; then
    # success, delete setup file
    rm -r "$GAMEDIR"/gamedata/*.sh
  fi
fi

mkdir -p "$GAMEDIR/conf"

# Set the XDG environment variables for config & savefiles
export XDG_DATA_HOME="$CONFDIR"

if [ -f "${controlfolder}/libgl_${CFW_NAME}.txt" ]; then 
  source "${controlfolder}/libgl_${CFW_NAME}.txt"
else
  source "${controlfolder}/libgl_default.txt"
fi

# Setup Box86

export LD_LIBRARY_PATH="$GAMEDIR/box86/native":"/usr/lib/arm-linux-gnueabihf/":"/usr/lib32":"$GAMEDIR/libs/":"$LD_LIBRARY_PATH"
export BOX86_LD_LIBRARY_PATH="$GAMEDIR/box86/x86":"$GAMEDIR/box86/native":"$GAMEDIR/libs/x86"
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"

# Use hacksdl to work round timing bug, where counter values reported
# by SDL are too large for La-Mulana to handle. This causes a delay of
# 10-15 minutes after the title screen
export HACKSDL_VERBOSE=1
export BOX86_LD_PRELOAD="$GAMEDIR/hacksdl-timing/hacksdl-timing.i386.so"

if [ "$LIBGL_FB" != "" ]; then
export SDL_VIDEO_GL_DRIVER="$GAMEDIR/gl4es/libGL.so.1"
export SDL_VIDEO_EGL_DRIVER="$GAMEDIR/gl4es/libEGL.so.1"
fi 

$GPTOKEYB "$BINARY" &
pm_platform_helper "$GAMEDIR/box86/box86"
$GAMEDIR/box86/box86 game/$BINARY
pm_finish

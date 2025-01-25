
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

GAMEDIR=/$directory/ports/aquaria
CONFDIR="$GAMEDIR/conf/"
BINARY=aquaria.aarch64

mkdir -p "$CONFDIR"

cd $GAMEDIR

> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1

# remove extraneous files
#rm -rf Config.dat DoConfig.exe OrgView.exe *.dll

# copy extra files into place
rsync -av $GAMEDIR/files/* $GAMEDIR/

bind_directories ~/.Aquaria $CONFDIR

# correct resolution
SETTINGS_FILE="$CONFDIR/preferences/usersettings.xml"
mv "$SETTINGS_FILE" "$SETTINGS_FILE.bak"
sed "s/resx=\"[0-9]*\"/resx=\"$DISPLAY_WIDTH\"/" "$SETTINGS_FILE.bak" |\
  sed "s/resy=\"[0-9]*\"/resy=\"$DISPLAY_HEIGHT\"/" > \
  "$SETTINGS_FILE"

export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"

if [ -f "${controlfolder}/libgl_${CFW_NAME}.txt" ]; then 
  source "${controlfolder}/libgl_${CFW_NAME}.txt"
else
  source "${controlfolder}/libgl_default.txt"
fi

if [ "$LIBGL_FB" != "" ]; then
export SDL_VIDEO_GL_DRIVER="$GAMEDIR/gl4es.aarch64/libGL.so.1"
export SDL_VIDEO_EGL_DRIVER="$GAMEDIR/gl4es.aarch64/libEGL.so.1"
fi

$GPTOKEYB "$BINARY" -c "./aquaria.gptk" &

pm_platform_helper "$GAMEDIR/$BINARY"

./$BINARY

pm_finish

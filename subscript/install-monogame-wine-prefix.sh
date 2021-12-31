#! /bin/bash

# This script is used to setup the needed Wine environment
# so that mgfxc can be run on Linux / macOS systems.

# check dependencies
if ! type "wine64" > /dev/null 2>&1
then
    echo "wine64 not found"
    exit 1
fi

if ! type "7z" > /dev/null 2>&1
then
    echo "7z not found"
    exit 1
fi

# init wine stuff
export WINEARCH=win64
export WINEPREFIX=$HOME/.winemonogame
wine64 wineboot

TEMP_DIR="${TMPDIR:-/tmp}"
SCRIPT_DIR="$TEMP_DIR/winemg2"
mkdir -p "$SCRIPT_DIR"

# disable wine crash dialog
cat > "$SCRIPT_DIR"/crashdialog.reg <<_EOF_
REGEDIT4
[HKEY_CURRENT_USER\\Software\\Wine\\WineDbg]
"ShowCrashDialog"=dword:00000000
_EOF_

pushd $SCRIPT_DIR
wine64 regedit crashdialog.reg
popd

##########################################
# dotnet 3.1
DOTNET_URL_31="https://download.visualstudio.microsoft.com/download/pr/adeab8b1-1c44-41b2-b12a-156442f307e9/65ebf805366410c63edeb06e53959383/dotnet-sdk-3.1.201-win-x64.zip"
curl $DOTNET_URL_31 --output "$SCRIPT_DIR/dotnet-sdk-31.zip"
7z x "$SCRIPT_DIR/dotnet-sdk-31.zip" -o"$WINEPREFIX/drive_c/windows/system32/"

# dotnet 5.0
DOTNET_URL="https://download.visualstudio.microsoft.com/download/pr/46b35cfe-4b3f-4e69-8831-0937196699b1/221f862c003a0175722c131b0941e3c4/dotnet-sdk-5.0.203-win-x64.zip"
curl $DOTNET_URL --output "$SCRIPT_DIR/dotnet-sdk.zip"
7z x "$SCRIPT_DIR/dotnet-sdk.zip" -aoa -o"$WINEPREFIX/drive_c/windows/system32/"

# d3dcompiler_47
FIREFOX_URL="https://download-installer.cdn.mozilla.net/pub/firefox/releases/62.0.3/win64/ach/Firefox%20Setup%2062.0.3.exe"
curl $FIREFOX_URL --output "$SCRIPT_DIR/firefox.exe"
7z x "$SCRIPT_DIR/firefox.exe" -o"$SCRIPT_DIR/firefox_data/"
cp -f "$SCRIPT_DIR/firefox_data/core/d3dcompiler_47.dll" "$WINEPREFIX/drive_c/windows/system32/d3dcompiler_47.dll"

# append MGFXC_WINE_PATH env variable
echo -e "\nexport MGFXC_WINE_PATH=$HOME/.winemonogame" >> ~/.profile
echo -e "\nexport MGFXC_WINE_PATH=$HOME/.winemonogame" >> ~/.zprofile

# cleanup
rm -rf "$SCRIPT_DIR"

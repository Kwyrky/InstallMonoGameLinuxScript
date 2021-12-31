#! /bin/bash
{
echo "+++++++++ `date "+%F %T"`: ${0##*/} $1 $2 $3 +++++++++"
set -x

INSTALL_SCRIPT_VERSION="1"

BASEDIR="$(dirname $0)"
BASENAME="$(basename $0)"

SUBSCRIPT_DIR="subscript"

SUBSCRIPT_WINE_PREFIX="install-monogame-wine-prefix.sh"
SUBSCRIPT_FONTS="install-monogame-fonts.sh"
SUBSCRIPT_TEMPLATE_DEMO="install-monogame-template-demo.sh"
SUBSCRIPT_CONTENT_DEMO="install-monogame-content-demo.sh"

SUBSCRIPT_WINE_PREFIX_PATH="$BASEDIR/$SUBSCRIPT_DIR/$SUBSCRIPT_WINE_PREFIX"
SUBSCRIPT_FONTS_PATH="$BASEDIR/$SUBSCRIPT_DIR/$SUBSCRIPT_FONTS"
SUBSCRIPT_TEMPLATE_DEMO_PATH="$BASEDIR/$SUBSCRIPT_DIR/$SUBSCRIPT_TEMPLATE_DEMO"
SUBSCRIPT_CONTENT_DEMO_PATH="$BASEDIR/$SUBSCRIPT_DIR/$SUBSCRIPT_CONTENT_DEMO"

wget "https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb" -O "/tmp/packages-microsoft-prod.deb"
sudo dpkg -i "/tmp/packages-microsoft-prod.deb"
sudo apt-get update

sudo apt-get -y install curl

sudo apt-get -y install apt-transport-https
sudo apt-get -y install dotnet-sdk-3.1
sudo apt-get -y install dotnet-sdk-5.0

sudo apt-get -y install gnupg ca-certificates
sudo apt-key adv --keyserver "hkp://keyserver.ubuntu.com:80" --recv-keys "3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee "/etc/apt/sources.list.d/mono-official-stable.list"
sudo apt-get update

sudo apt-get -y install mono-devel

curl "https://packages.microsoft.com/keys/microsoft.asc" | gpg --dearmor > "/tmp/packages.microsoft.gpg"
sudo install -o root -g root -m 644 "/tmp/packages.microsoft.gpg" "/etc/apt/trusted.gpg.d/"
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update

sudo apt-get -y install code

code --install-extension ms-dotnettools.csharp

dotnet new --install MonoGame.Templates.CSharp

dotnet tool install --global dotnet-mgcb-editor
"$HOME/.dotnet/tools/mgcb-editor" --register

sudo apt-get -y install wine64
sudo apt-get -y install p7zip-full

source "$SUBSCRIPT_WINE_PREFIX_PATH"
source "$SUBSCRIPT_FONTS_PATH"

source "$HOME/.profile"

sudo apt-get -y install git

source "$SUBSCRIPT_TEMPLATE_DEMO_PATH"
source "$SUBSCRIPT_CONTENT_DEMO_PATH"

echo "Installation script finished! :-)"
echo "Please restart the session (logout / login or restart) for all changes to take effect!"

set +x
} 2>&1 | tee -a "/tmp/${0##*/}.log" | grep -v '^+'

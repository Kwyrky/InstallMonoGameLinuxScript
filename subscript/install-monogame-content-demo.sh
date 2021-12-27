#! /bin/bash

BASEDIR="$(dirname $0)"
BASENAME="$(basename $0)"

SOLUTION="MonoGameContentDemo"
PROJECT="MonoGameContentDemo.OpenGL"

SLNDIR="$BASEDIR/$SOLUTION"

git clone "https://github.com/Kwyrky/MonoGameContentDemo.git" "$SLNDIR"

dotnet run --project "${SLNDIR}/${PROJECT}/${PROJECT}.csproj"

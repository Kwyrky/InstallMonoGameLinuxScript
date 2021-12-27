#! /bin/bash

BASEDIR="$(dirname $0)"
BASENAME="$(basename $0)"

SOLUTION="MonoGameTemplateDemo"
PROJECT="MonoGameTemplateDemo.OpenGL"

SLNDIR="$BASEDIR/$SOLUTION"

mkdir -p "$SLNDIR"
cd "$SLNDIR"
dotnet new mgdesktopgl -o "$PROJECT"
dotnet new sln -n "$SOLUTION"
dotnet sln add "${PROJECT}/${PROJECT}.csproj"

dotnet run --project "${SLNDIR}/${PROJECT}/${PROJECT}.csproj"

#!/bin/bash
dotnet restore
dotnet publish -r osx-arm64 --configuration Release -p:UseAppHost=true

# Define variables
APP_NAME="TestApp.app"
ZIP_FILE="TestApp.zip"
PUBLISH_OUTPUT_DIRECTORY="bin/Release/net8.0/osx-arm64/publish"
INFO_PLIST="Info.plist"
ICON_FILE="AppIcon.icns"

# Remove old .app bundle if it exists
if [ -d "$APP_NAME" ]; then
    rm -rf "$APP_NAME"
fi

# Create the .app bundle structure
mkdir -p "$APP_NAME/Contents/MacOS"
mkdir -p "$APP_NAME/Contents/Resources"

# Copy the Info.plist file and the icon
cp "$INFO_PLIST" "$APP_NAME/Contents/Info.plist"
cp "$ICON_FILE" "$APP_NAME/Contents/Resources/AppIcon.icns"

# Copy the published output to the MacOS directory
cp -a "$PUBLISH_OUTPUT_DIRECTORY/." "$APP_NAME/Contents/MacOS"

echo "Packaged $APP_NAME successfully."

mkdir -p "Setup/output"

cp "$APP_NAME" "Setup/output/$APP_NAME"

chmod +x Setup/output/start.sh

# Zip the .app bundle
#zip -r "Setup/output/$ZIP_FILE" "$APP_NAME"
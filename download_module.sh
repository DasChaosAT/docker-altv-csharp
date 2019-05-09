#!/bin/sh
wget -O libcsharp-module.json --no-cache https://api.github.com/repos/FabianTerhorst/coreclr-module/releases/latest
jq '.assets[]|select(.name=="libcsharp-module.so")|.browser_download_url' libcsharp-module.json | xargs wget --no-cache
rm libcsharp-module.json
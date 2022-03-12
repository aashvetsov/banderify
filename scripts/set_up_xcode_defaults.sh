#!/usr/bin/env bash

set -Eeuo pipefail

readonly XCODE_DEFAULTS_DOMAIN="com.apple.dt.Xcode"

echo "> SETUP XCODE DEFAULTS "

(set -x
defaults write $XCODE_DEFAULTS_DOMAIN DVTTextEditorTrimTrailingWhitespace -bool NO
defaults write $XCODE_DEFAULTS_DOMAIN DVTTextEditorTrimWhitespaceOnlyLines -bool YES
defaults write $XCODE_DEFAULTS_DOMAIN DVTTextIndentTabWidth -int 4
defaults write $XCODE_DEFAULTS_DOMAIN DVTTextIndentWidth -int 4
defaults write $XCODE_DEFAULTS_DOMAIN DVTTextPageGuideLocation -int 120
defaults write $XCODE_DEFAULTS_DOMAIN DVTTextShowInvisibleCharacters -bool NO)

echo "Done"

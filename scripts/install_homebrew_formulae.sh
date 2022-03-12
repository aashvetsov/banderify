#!/usr/bin/env bash

set -Eeuo pipefail

readonly HOMEBREW_INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

function install_homebrew() {
    echo "> INSTALL HOMEBREW "

    bash -c "$(curl -fsSL $HOMEBREW_INSTALL_SCRIPT_URL)"

    echo "Done"
}

function homebrew_install_formula() {
    local -r formula="$1"

    if ! brew list "$formula" &>/dev/null
    then
        echo "Installing $formula..."
        brew install "$formula" >/dev/null
    else
        echo "Formula $formula is already installed."
    fi
}

if ! command -v "brew" &>/dev/null
then
    echo "Could not find 'brew' command and Homebrew is required to continue."
    echo
    read -r -p "Press RETURN to install it or CTRL+C to abort"
    install_homebrew
fi

echo "> INSTALL HOMEBREW FORMULAE "

homebrew_install_formula "swiftlint"

echo "Done"

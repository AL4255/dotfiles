#!/usr/bin/env bash
# Bootstrap nvim + tmux on any machine (Mac or Linux VM).
# Usage: git clone https://github.com/AL4255/dotfiles ~/.dotfiles && ~/.dotfiles/setup.sh

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_packages() {
    if command -v brew &> /dev/null; then
        brew install neovim tmux
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y neovim tmux
    elif command -v yum &> /dev/null; then
        sudo yum install -y neovim tmux
    elif command -v pacman &> /dev/null; then
        sudo pacman -Sy --noconfirm neovim tmux
    else
        echo "Could not detect a package manager. Install neovim + tmux manually." >&2
    fi
}

if ! command -v nvim &> /dev/null || ! command -v tmux &> /dev/null; then
    echo "Installing neovim/tmux..."
    install_packages
fi

backup_and_link() {
    local target="$1" source="$2"
    if [ -e "$target" ] || [ -L "$target" ]; then
        mv "$target" "$target.backup"
    fi
    mkdir -p "$(dirname "$target")"
    ln -sf "$source" "$target"
}

backup_and_link ~/.config/nvim "$DOTFILES/nvim"
backup_and_link ~/.tmux.conf "$DOTFILES/tmux/.tmux.conf"

echo "nvim + tmux linked. Start tmux, open nvim, run :Lazy to sync plugins."

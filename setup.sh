#!/usr/bin/env bash
# Bootstrap zsh, nvim, tmux, starship (and kitty, if a GUI is present) on any machine
# (Mac, Linux desktop, or a headless Linux VM).
# Usage: git clone https://github.com/AL4255/dotfiles ~/dotfiles && ~/dotfiles/setup.sh

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Kitty is a GUI terminal emulator; skip it entirely on headless machines.
HAS_GUI=false
if [[ "$(uname -s)" == "Darwin" ]] || [[ -n "$DISPLAY" ]] || [[ -n "$WAYLAND_DISPLAY" ]]; then
    HAS_GUI=true
fi

install_starship() {
    command -v starship &> /dev/null && return
    if command -v curl &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    elif command -v wget &> /dev/null; then
        wget -qO- https://starship.rs/install.sh | sh -s -- -y
    else
        echo "Neither curl nor wget found; install starship manually: https://starship.rs" >&2
    fi
}

install_packages() {
    if command -v brew &> /dev/null; then
        brew install neovim tmux starship curl
        $HAS_GUI && brew install --cask kitty
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y neovim tmux zsh curl
        install_starship
        $HAS_GUI && sudo apt-get install -y kitty
    elif command -v yum &> /dev/null; then
        sudo yum install -y neovim tmux zsh curl
        install_starship
        $HAS_GUI && sudo yum install -y kitty
    elif command -v pacman &> /dev/null; then
        sudo pacman -Sy --noconfirm neovim tmux starship zsh curl
        $HAS_GUI && sudo pacman -Sy --noconfirm kitty
    else
        echo "Could not detect a package manager. Install neovim, tmux, zsh, and starship manually." >&2
    fi
}

if ! command -v nvim &> /dev/null || ! command -v tmux &> /dev/null || ! command -v starship &> /dev/null || ! command -v zsh &> /dev/null; then
    echo "Installing neovim/tmux/zsh/starship..."
    install_packages
fi

if command -v zsh &> /dev/null && [[ "$SHELL" != *zsh ]]; then
    echo "Setting zsh as your default shell..."
    chsh -s "$(command -v zsh)" || echo "Could not chsh automatically; run manually: chsh -s $(command -v zsh)"
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
backup_and_link ~/.zshrc "$DOTFILES/zsh/.zshrc"
backup_and_link ~/.config/starship/starship.toml "$DOTFILES/starship/starship.toml"

if $HAS_GUI && command -v kitty &> /dev/null; then
    backup_and_link ~/.config/kitty/kitty.conf "$DOTFILES/kitty/kitty.conf"
fi

echo "Linked. Run 'exec zsh' (or log out and back in) to switch this session to zsh, start tmux, open nvim and run :Lazy to sync plugins."
echo "Add machine-specific secrets/overrides to ~/.zshrc.local (not tracked in git)."

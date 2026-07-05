# dotfiles

Personal dotfiles for zsh, tmux, Neovim (LazyVim), starship, and kitty. Works on macOS,
Linux desktops, and headless Linux VMs (kitty is skipped automatically when there's no
GUI, since it's just a terminal emulator).

## Quick start

```bash
git clone https://github.com/AL4255/dotfiles ~/dotfiles
~/dotfiles/setup.sh
```

This installs missing packages (via brew/apt/yum/pacman) and symlinks configs into
place, backing up anything already there as `<file>.backup`.

## What's included

- `zsh/.zshrc` — shell config, aliases, history/completion settings
- `tmux/.tmux.conf` — tmux config
- `nvim/` — full LazyVim config (drop-in replacement for `~/.config/nvim`)
- `starship/starship.toml` — shell prompt theme (Catppuccin Mocha)
- `kitty/kitty.conf` — terminal emulator config (GUI only)
- `bin/coding-session` — tmux script that opens a 3-pane layout (nvim / claude / shell)

## Secrets / machine-specific config

Don't commit API keys or anything machine-specific. Instead put them in
`~/.zshrc.local` — it's sourced automatically at the end of `.zshrc` but is not
tracked by this repo.

```bash
# ~/.zshrc.local
export ANTHROPIC_API_KEY="..."
```

## Updating

```bash
cd ~/dotfiles && git pull
```

# config-for-servers

Lightweight dotfiles for remote Linux servers: bash, tmux, and Vim. No plugins
or extra packages needed, so they work on a fresh server right away.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/azeddine-hmd/config-for-servers/main/install.sh | bash
```

The script downloads `.bashrc`, `.tmux.conf`, and `.vimrc` into your home
directory. Any existing files are moved to `~/.dotfiles-backup/<timestamp>/`
first, so nothing is lost. Only `curl` is required.

If you prefer to review the script before running it:

```bash
curl -fsSL https://raw.githubusercontent.com/azeddine-hmd/config-for-servers/main/install.sh -o install.sh
less install.sh
bash install.sh
```

Then apply the changes:

```bash
source ~/.bashrc
tmux source-file ~/.tmux.conf   # only if tmux is already running
```

### Restore old files

```bash
ls ~/.dotfiles-backup/
cp ~/.dotfiles-backup/<timestamp>/.bashrc ~/
```

## What's included

| File           | Purpose                                                    |
| -------------- | ---------------------------------------------------------- |
| `.bashrc`      | Ubuntu-style defaults plus a few aliases and tweaks        |
| `.tmux.conf`   | `Ctrl-a` prefix, Vim-style keys, mouse, custom theme       |
| `.vimrc`       | Sensible defaults, `desert` theme, Space as leader         |
| `install.sh`   | Installer with automatic backup                            |
| `CLIPBOARD.md` | Guide for copying from remote Vim to the Windows clipboard |

## bash

Based on the standard Ubuntu `.bashrc`, with these additions:

| Alias / setting | Effect                                         |
| --------------- | ---------------------------------------------- |
| `dc`            | `docker compose`                               |
| `sdc`           | `sudo docker compose`                          |
| `ll`, `la`, `l` | Common `ls` shortcuts                          |
| vi mode         | Enabled automatically inside tmux only         |
| `Ctrl-l`        | Clears the screen (also in vi mode)            |
| `Ctrl-s`        | Forward history search (flow control disabled) |
| `EDITOR`        | Set to `vim`                                   |

## tmux

The prefix is **`Ctrl-a`** instead of `Ctrl-b`.

| Keys                     | Action                              |
| ------------------------ | ----------------------------------- |
| `prefix` `r`             | Reload config                       |
| `prefix` `h` `j` `k` `l` | Move between panes                  |
| `prefix` `H` `J` `K` `L` | Resize pane (repeatable)            |
| `prefix` `c`             | New window in the current directory |
| `prefix` `"`             | Split horizontally, keep directory  |
| `prefix` `%`             | Split vertically, keep directory    |
| `prefix` `[`             | Enter copy mode (vi keys)           |
| `v` / `y` (copy mode)    | Start selection / copy and exit     |

Other settings: mouse support, 50,000-line scrollback, no Escape delay for Vim,
focus events for Vim's `autoread`, `tmux-256color`, and a dark status bar with
a green accent.

## Vim

The leader key is **Space**.

| Keys        | Action                                                     |
| ----------- | ---------------------------------------------------------- |
| `Space` `e` | Open the file explorer (netrw) in a 15-column left pane    |
| `Space` `c` | Toggle line numbers, for clean mouse selection and copying |

Other settings: syntax highlighting and filetype detection, mouse support,
4-space indentation, smart case-insensitive search with highlighting, no swap or
backup files, no bells, auto-reload of files changed on disk, and the built-in
`desert` color scheme.

## Copying to the Windows clipboard

When working from Windows Terminal + WSL over SSH, the server has no clipboard
of its own. See [CLIPBOARD.md](CLIPBOARD.md) for setting up OSC 52 so that
yanking in Vim on the server copies straight to the Windows clipboard.

## License

[MIT](LICENSE)

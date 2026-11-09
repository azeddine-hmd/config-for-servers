# Copy from remote Vim to the Windows clipboard (WSL + tmux + SSH)

Setup for copying text from Vim on a remote server, over SSH, into the Windows
clipboard, even though the server has no clipboard support.

```
Vim (server) -> tmux (server) -> SSH -> tmux (WSL) -> Windows Terminal -> Windows clipboard
```

It works through **OSC 52**, an escape sequence that asks the terminal to put
text in the clipboard. It travels over SSH as plain text, so the server needs no
clipboard. Each tmux layer has to be told to pass it through.

---

## 1. tmux on WSL

`~/.tmux.conf`:

```tmux
set -g set-clipboard on
set -as terminal-features ',xterm-256color:clipboard'
```

`terminal-features` requires tmux 3.2 or newer.

---

## 2. tmux on the server

`~/.tmux.conf`:

```tmux
set -g set-clipboard on
```

Then add **one** of the following, depending on `tmux -V`.

**tmux 3.2 or newer:**

```tmux
set -as terminal-features ',tmux*:clipboard,screen*:clipboard,xterm*:clipboard'
```

**tmux older than 3.2** (where `terminal-features` gives "invalid option"):

```tmux
set -ga terminal-overrides ',screen*:Ms=\E]52;%p1%s;%p2%s\007,tmux*:Ms=\E]52;%p1%s;%p2%s\007,xterm*:Ms=\E]52;%p1%s;%p2%s\007'
```

Keep the single quotes exactly as written.

The `tmux*` and `screen*` entries are needed because inside the WSL tmux,
`TERM` is `tmux-256color` or `screen-256color`, and by default tmux does not
assume those terminals can set the clipboard.

---

## 3. Vim on the server (vim-oscyank)

Install [vim-oscyank](https://github.com/ojroques/vim-oscyank) with Vim's
built-in package system:

```bash
mkdir -p ~/.vim/pack/plugins/start
git clone https://github.com/ojroques/vim-oscyank ~/.vim/pack/plugins/start/vim-oscyank
```

If the server has no internet access, clone it in WSL and copy it over:

```bash
git clone https://github.com/ojroques/vim-oscyank
ssh user@server 'mkdir -p ~/.vim/pack/plugins/start'
scp -r vim-oscyank user@server:~/.vim/pack/plugins/start/
```

`~/.vimrc`:

```vim
" Send every normal yank to the system clipboard via OSC 52
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister "' | endif
```

If the copy still does not arrive with an old server tmux, also add:

```vim
" Wrap the sequence so it passes straight through the server's tmux
let g:oscyank_term = 'tmux'
```

### Usage

| Action              | Keys / command          |
| ------------------- | ----------------------- |
| Copy the whole file | `:%y`                   |
| Copy a line         | `yy`                    |
| Copy a selection    | `v` / `V`, then `y`     |

On success Vim shows `[oscyank] N characters copied`.

---

## 4. Optional: no-plugin fallback

On the server, create `~/bin/osc52copy`:

```bash
#!/bin/bash
printf "\e]52;c;%s\a" "$(base64 -w0)" > /dev/tty
```

```bash
chmod +x ~/bin/osc52copy
```

Usage:

```vim
:w !osc52copy           " whole file
:'<,'>w !osc52copy      " selected lines
```

From the shell: `osc52copy < file.txt`

---

## Applying changes

`terminal-features` and `terminal-overrides` are read when a client attaches,
so reloading the config is not enough. After editing either `~/.tmux.conf`:

```bash
tmux source ~/.tmux.conf
# prefix + d to detach, then:
tmux attach
```

---

## Troubleshooting

Check the WSL tmux:

```bash
tmux show -s set-clipboard   # should print: set-clipboard on
tmux info | grep Ms          # should show an Ms: capability, not [missing]
```

Test one layer at a time. Run this at each level, then paste in Windows:

```bash
printf "\e]52;c;%s\a" "$(echo hello | base64 -w0)"
```

1. In WSL tmux, before SSH: tests Windows Terminal and the WSL tmux.
2. Over SSH, outside the server tmux: tests the SSH path.
3. Inside the server tmux: tests the server tmux config.

The first level where `hello` does not reach the clipboard is the layer to fix.

---

## Large files

Terminals and tmux limit OSC 52 payloads (roughly tens to hundreds of KB).
For large files, skip the terminal and run this from WSL:

```bash
ssh user@server 'cat /path/to/file' | clip.exe
```

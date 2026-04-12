# Shell Scripts — Claude Context

Personal shell scripts for an Arch Linux + dwm desktop setup.

## POSIX Compliance (Priority Rule)

**Always write new scripts with `#!/bin/sh` and POSIX-compliant syntax so they run under `dash`.**

Forbidden constructs (bash-specific):
- `[[ ]]` — use `[ ]`
- `$(( ))` arithmetic with `let`/`(( ))` — use `$(( ))` which is POSIX, but avoid `(( ))`
- `local` in functions is accepted by dash but is not POSIX; avoid if possible
- Bash arrays (`arr=(...)`, `${arr[@]}`) — use loops or space-separated strings instead
- `echo -e` — use `printf`
- `read -r -p "prompt"` with `-p` — use `printf` then `read -r`
- `source` — use `.`
- `&>>`, `>>file 2>&1` preferred over `&>>`
- `${var,,}` / `${var^^}` case transforms — use `tr`
- `mapfile` / `readarray`
- Brace expansion `{a,b,c}` in `sh`

## Environment

- **OS:** Arch Linux
- **WM:** dwm with dwmblocks status bar
- **Shell:** fish (interactive), dash/sh (scripts)
- **Audio:** PipeWire / PulseAudio (`pactl`, `bluetoothctl`)
- **Notifications:** `dunst` + `notify-send`
- **Launcher:** `dmenu`
- **Editor:** Neovim
- **Multiplexer:** tmux
- **Bluetooth:** `bluetoothctl`

## Common Patterns

### dwmblocks signals
```sh
kill -45 $(pidof dwmblocks)   # backlight block
kill -44 $(pidof dwmblocks)   # audio/volume block
kill -46 $(pidof dwmblocks)   # bluetooth block
pkill -RTMIN+14 dwmblocks     # DND state
```

### dmenu selection
```sh
choice=$(printf 'Option A\nOption B' | dmenu -p "Prompt:")
```

### dmenu confirmation (uses prompt.sh)
```sh
sh "$HOME/.scripts/prompt.sh" "Are you sure?" || exit 0
```

### Notifications
```sh
notify-send "Title" "Body"
notify-send -u critical "Title" "Urgent message"
```

### Sensitive credentials
Stored in `~/.scripts/.env/` (mode 700, git-ignored). Source with:
```sh
. "$HOME/.scripts/.env/service-name"
```

## Profiles

Two desktop profiles exist:
- **pessoal** — personal setup (web services, personal tmux)
- **work** — work setup (work tmux, VPN, work services)

## Script Conventions

- No extension for commands meant to be run directly (e.g., `web`, `work`, `timezone`)
- `.sh` suffix for utility/sourced scripts
- Naming: `conectar-*` / `desconectar-*` for Bluetooth, `backup-*` for backups, `start-*` / `stop-*` for services
- State/cache files go in `/tmp/` or `~/.cache/`
- Use `set -e` for scripts where partial execution would leave bad state
- Log errors to stderr: `printf 'error: %s\n' "msg" >&2`

# AGENTS.md

Personal Ubuntu bootstrap / dotfiles repo. Everything lives under `home/` and is
symlinked into `$HOME` by `make sync`. There is no build, test, lint, or CI —
this is a declarative config repo.

## Layout

- `home/` — mirror of `$HOME`. Every file here becomes a symlink at `~/<path>`.
  Editing files in this repo **directly affects the live environment** after
  `make sync`. Add new files under `home/` and they will be linked on next sync.
- `Makefile` — the only entry point. No package.json, no scripts dir.
- `home/.images/` — `Containerfile`s for the `opencode.sh` / `claude.sh` wrappers.
- `home/.config/opencode/AGENTS.md` — **opencode's runtime instructions inside
  the podman container**, a separate concern from this file. Do not confuse the two.

## Commands

- `make` / `make all` — full bootstrap. Target order is fixed in the first line
  of the Makefile and matters: `sync` runs first (creates the symlinks the other
  targets rely on), then system tools are installed.
- `make sync` — recreates the `home/ → ~/` symlinks. Idempotent; run after any
  edit to files under `home/`.
- `make <target>` — run a single step. Most targets (`k9s`, `helm`, `sops`,
  `kubectl`, `nvim`, etc.) download a pinned binary release straight into
  `~/.local/bin/`. Versions are hardcoded in the Makefile — bump them there.
- `make uv_pkgs` — installs `tldr beautysh ruff pyright` via `uv tool install`.
- `make apt` / `make snap` — require `sudo`, mutate the system.

## Conventions

- Binaries go to `~/.local/bin/` (on `$PATH` via `.bash_aliases`), never system-wide.
- nvim is installed to `~/.local/opt/nvim/` and symlinked into `~/.local/bin/`.
- Tool versions are pinned in the Makefile and in the Dockerfiles under
  `home/.images/`. Keep the two in sync when relevant.
- Secrets are **not** committed in plaintext. `home/.local/bin/opencode.sh`
  embeds GPG-encrypted blobs and decrypts them at runtime using
  `GNUPGHOME=~/places/gpg` (set in `.bash_aliases`).

## Gotchas

- `Makefile` `kubectl` target has a copy-paste bug: it chmods `yamlfmt`
  instead of `kubectl` (line ~84). The binary lands unexecutable.
- `opencode.sh` / `claude.sh` rebuild their podman image on **every** invocation
  (`podman build` then `podman run --rm`). They mount the current `$PWD` as rw.
- `make sync` uses `ln -sfr`, so it will **overwrite** existing paths in `$HOME`
  that collide with files under `home/`. There is no backup step.
- `.bash_aliases` sets `cat="batcat"` — assume `cat` is bat on this system.
- `.kube/config` points at `http://localhost:8081` (a local proxy), not a real cluster.

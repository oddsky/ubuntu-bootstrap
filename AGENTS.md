# AGENTS.md

This repository is an Ubuntu bootstrapping setup managed primarily via `Makefile`.

## Primary Commands
- `make`: Runs the full bootstrap process (`sync`, `dconf`, `apt`, `snap`, `arch`, `helm`, `zsh`, `fonts`, `ktalk`, `nvim`).
- `make [target]`: Runs a specific setup step (e.g., `make apt`, `make dconf`).

## Operational Warnings
- **Dangerous Commands (`sync`)**: The `make sync` command recursively replicates the repository's directory structure into `~/`. It uses `find` and `ln -sfr` to create symbolic links for every file (excluding `.git/*`) from the repo into the user's home directory. Modifying files here *directly* impacts your `~/` environment.
- **System Modifications**: The `Makefile` runs `sudo apt`, `sudo snap`, and `dconf` commands. It *will* modify the system state, install software, and change Gnome settings.
- **Podman Usage**: The `arch` target uses `podman` to pull an `archlinux` container to install specific packages (`kubectl`, `helm`, etc.) and copies binaries to `~/.local/bin/`. Ensure `podman` is available and configured.

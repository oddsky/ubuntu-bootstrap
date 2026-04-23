#!/usr/bin/env python3

import subprocess
import sys
from pathlib import Path

MIN_PARTS = 2


def get_ssh_config_hosts() -> set[str]:
    hosts = set()
    ssh_dir = Path("~/.ssh").expanduser()
    files = [ssh_dir / "config"]
    config_d = ssh_dir / "config.d"
    if config_d.is_dir():
        files.extend(config_d.glob("*"))

    for file_path in files:
        try:
            with file_path.open() as f:
                for line in f:
                    stripped_line = line.strip()
                    if not stripped_line or stripped_line.startswith("#"):
                        continue
                    parts = stripped_line.split()
                    if len(parts) >= MIN_PARTS and parts[0].lower() in (
                        "host",
                        "hostname",
                    ):
                        for host in parts[1:]:
                            if not any(c in host for c in "*?%"):
                                hosts.add(host)
        except OSError:
            continue
    return hosts


def main():
    hosts = sorted(get_ssh_config_hosts())

    process = subprocess.Popen(
        ["/usr/bin/fzf"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        text=True,
        env={
            "FZF_DEFAULT_OPTS": "--bind=alt-k:up,alt-j:down --reverse --style=minimal"
        },
    )
    stdout, _ = process.communicate(input="\n".join(hosts))
    host = stdout.strip()

    if not host:
        sys.exit()

    subprocess.run(
        ["/usr/bin/tmux", "new-window", "-n", host, "ssh", host],
        check=False,
    )


if __name__ == "__main__":
    main()

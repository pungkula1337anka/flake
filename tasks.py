import os
import subprocess
import socket
import sys
import time
from pathlib import Path
from tempfile import TemporaryDirectory
from invoke import task

ROOT = Path(__file__).parent.resolve()
os.chdir(ROOT)

class DeployHost:
    def __init__(self, host: str):
        self.host = host

    def run(self, command: str):
        subprocess.run(f"ssh {self.host} '{command}'", shell=True)

    def run_local(self, command: str, stdout=subprocess.PIPE):
        return subprocess.run(command, shell=True, stdout=stdout)


def wait_for_host(h: DeployHost, shutdown: bool = False) -> None:
    while True:
        try:
            socket.create_connection((h.host, 22), timeout=5)
            if not shutdown:
                return
        except socket.error:
            if shutdown:
                return
        time.sleep(1)
        print(".", end="")
        sys.stdout.flush()

@task
def deploy(c, host):
    """invoke --deploy {hostname}\nPulls fresh flake from GitHub and rebuilds Nix OS on specified host."""
    subprocess.run(f"ssh {host} 'git pull && systemctl restart app'", shell=True)

@task
def commit(c, host):
    """invoke --commmit . Push and commit flake repository to GitHub."""
    pass

@task
def reboot(c, host):
    """Reboot a server."""
    subprocess.run(f"ssh {host} 'sudo reboot'", shell=True)

@task
def install(c, flake_attr: str, hostname: str) -> None:
    """Install NixOS on a host machine."""
    ask = input(f"Install {hostname} with {flake_attr}? [y/N] ")
    if ask != "y":
        return
    with TemporaryDirectory() as d:
        root = Path(d) / "root"
        root.mkdir(parents=True, exist_ok=True)
        root.chmod(0o755)
        host_key = root / "etc/ssh/ssh_host_ed25519_key"
        host_key.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run(
            [
                "sops",
                "--extract",
                '["ssh_host_ed25519_key"]',
                "-d",
                f"nixos/{flake_attr}/secrets/secrets.yaml",
            ],
            check=True,
            stdout=host_key.open("w"),
        )
        c.run(
            f"nix run github:numtide/nixos-anywhere -- {hostname} --debug --flake .#{flake_attr} --extra-files {root}",
            echo=True,
        )

@task
def add_key(c, hosts: str = "", github_user: str = "QuackHack-McBlindy") -> None:
    """Download SSH key from GitHub user account."""
    g = parse_hosts(hosts, host_key_check=HostKeyCheck.NONE)

    def add_user(h: DeployHost):
        h.run("mkdir -m700 /root/.ssh")
        out = h.run_local(
            f"curl https://github.com/{github_user}.keys",
            stdout=subprocess.PIPE,
        )
        h.run(
            f"echo '{out.stdout.decode()}' >> /root/.ssh/authorized_keys && chmod 700 /root/.ssh/authorized_keys",
        )

    g.run_function(add_user)

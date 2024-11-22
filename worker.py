from invoke import task
import subprocess

@task
def deploy(c, host):
    """Deploy code to a server."""
    subprocess.run(f"ssh {host} 'git pull && systemctl restart app'", shell=True)

@task
def reboot(c, host):
    """Reboot a server."""
    subprocess.run(f"ssh {host} 'sudo reboot'", shell=True)




@task
def install_machine(c: Any, flake_attr: str, hostname: str) -> None:
    """Install nixos on a machine"""
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

def wait_for_reboot(h: DeployHost) -> None:
    print(f"Wait for {h.host} to shutdown", end="")
    sys.stdout.flush()
    wait_for_host(h, shutdown=True)
    print()

    print(f"Wait for {h.host} to start", end="")
    sys.stdout.flush()
    wait_for_host(h, shutdown=True)
    print()


@task
def add_github_user(c: Any, hosts: str = "", github_user: str = "QuackHack-McBlindy") -> None:
    """Download SSH key from GitHub user."""
        h.run("mkdir -m700 /root/.ssh")
        out = h.run_local(
            f"curl https://github.com/{github_user}.keys",
            stdout=subprocess.PIPE,
        )
        h.run(
            f"echo '{out.stdout}' >> /root/.ssh/authorized_keys && chmod 700 /root/.ssh/authorized_keys",
        )

    g = parse_hosts(hosts, host_key_check=HostKeyCheck.NONE)
    g.run_function(add_user)


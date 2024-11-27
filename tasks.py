import os
import shutil
import subprocess
import socket
import sys
import time
from pathlib import Path
#from tempfile import TemporaryDirectory
import tempfile
from invoke import task

#from rich.console import Console
#from rich.text import Text
#from rich.table import Table
#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#──→ SETTINGS ←──
#console = Console()



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


#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#──→ PULL ←──
@task
def pull(c, host=None):
    """Pulls flake from GitHub."""
    repo_path = "/home/pungkula/flake"
    cmd = f"cd {repo_path} && git pull origin main"
    
    if host:
        print(f"Kör på host {host}: {cmd}")
        c.run(f"ssh {host} '{cmd}'")
    else:
        print(f"Kör lokalt: {cmd}")
        c.run(cmd)

#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#──→ DEPLOY ←──
#@task
#def deploy(c, host):
#    """Pulls fresh flake from GitHub and rebuilds Nix OS on specified host."""
#    subprocess.run(f"ssh {host} 'git pull && systemctl restart app'", shell=True)


#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#──→ PUSH ←──
@task
def push(c, host):
    """Push flake to GitHub."""
    subprocess.run(f"git add -A && git commit -m 'invoke git update' && git push", shell=True)

#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#──→ REBOOT ←──
@task
def reboot(c, host):
    """Reboot a server."""
    subprocess.run(f"ssh {host} 'sudo reboot'", shell=True)





#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#──→ INSTALL ←──
@task
def install(c, host: str) -> None:
    """Installs NixOS on the host machine."""
    ask = input(f"WARNING: THIS WILL DELETE EVERYTHING ON LOCAL DISK! "
                f"Are you sure you wish to install a fresh NixOS installation on {host}? [y/N] ")
    if ask.lower() != "y":
        print("Installation aborted.")
        return

    #with TemporaryDirectory() as temp_dir:
        #root = Path(temp_dir) / "root"
        #root.mkdir(parents=True, exist_ok=True)
        #root.chmod(0o755)

        # Path to the original SSH key
        #ssh_key_source = Path("/home/pungkula/.ssh/id_ed25519.pub")
        
        # Ensure the destination directory exists
        #host_key_dest = root / "tmp/ssh_host_ed25519_key"
        #host_key_dest.parent.mkdir(parents=True, exist_ok=True)  # Create the parent directory
        
        # Copy the SSH key to the temporary directory (tmp folder)
        #shutil.copy(ssh_key_source, host_key_dest)
        
        # Make sure the permissions are correct for the SSH key
        #host_key_dest.chmod(0o600)

    try:
        # Command to install NixOS using nixos-anywhere
        #pubkeys = "/home/pungkula/.ssh/extra-files/.ssh"
        c.run(
            f"nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hosts/{host}/hardware-configuration.nix --debug --flake .#{host} --copy-host-keys root@laptop",
            echo=True,
        )
    except Exception as e:
        print(f"Error during installation: {e}")




    




#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#──→ LOGS ←──
@task
def logs(ctx, host, lines=50):
    """Displays logs from the specified host machine."""
    console.print(f"[bold green]Fetching logs from {host}...[/bold green]")
    result = ctx.run(f"ssh {host} 'sudo journalctl -xe | tail -n {lines}'", hide=True)
    logs = result.stdout.splitlines()

    # Create a table to display logs
    table = Table(show_header=True, header_style="bold cyan")
    table.add_column("Timestamp", style="dim", no_wrap=True)
    table.add_column("Service", style="magenta")
    table.add_column("Message", style="white")

    for log in logs:
        if "timestamp" in log.lower():  # Replace with actual timestamp detection logic
            timestamp, service, message = parse_log_entry(log)
            table.add_row(timestamp, service, message)
        else:
            table.add_row("[dim]-[/dim]", "[dim]-[/dim]", log)

    console.print(table)

def parse_log_entry(log):
    """Parses a log entry into timestamp, service, and message parts."""
    parts = log.split()  # Simplistic split logic; adjust for actual log format
    timestamp = " ".join(parts[:2])  # Adjust to capture timestamp (e.g., "2024-11-26 14:32:01")
    service = parts[2] if len(parts) > 2 else "Unknown"
    message = " ".join(parts[3:]) if len(parts) > 3 else "No message"
    return timestamp, service, message


#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#──→ HARDWARE ANALYSIS ←──


#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#──→ ADD KEY ←──
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

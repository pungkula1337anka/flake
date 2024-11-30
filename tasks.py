import os
import shutil
import subprocess
import socket
import sys
import time
from pathlib import Path
from tempfile import TemporaryDirectory
import tempfile
from invoke import task


#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#──→ SETTINGS ←──

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

    # Path to your SSH public key
    ssh_key_source = Path("/home/pungkula/.ssh/id_ed25519.pub")
    if not ssh_key_source.exists():
        print(f"SSH public key not found: {ssh_key_source}")
        return

    # Create a temporary directory to stage files
    with TemporaryDirectory() as temp_dir:
        temp_dir_path = Path(temp_dir)
        extra_files_dir = temp_dir_path / "extra-files"
        extra_files_dir.mkdir(parents=True, exist_ok=True)

        # Copy the SSH public key to the temporary directory
        ssh_key_dest = extra_files_dir / "id_ed25519.pub"
        shutil.copy(ssh_key_source, ssh_key_dest)

        # Run nixos-anywhere with the prepared files
        pubkeys = "/home/pungkula/.ssh/extra-files/"
        try:
            c.run(
                 f"nix run github:numtide/nixos-anywhere -- --debug --flake .#{host} --extra-files {pubkeys}",
                echo=True,
            )
        except Exception as e:
            print(f"Error during installation: {e}")



    




#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°°✶.•°•.•°•.•°•.✶°
#──→ LOGS ←──
from invoke import task
import re  # For extracting and formatting timestamps

# ANSI escape codes for clear and simple colors
class Colors:
    RESET = "\033[0m"
    RED = "\033[31;1m"  # Bright red for critical errors
    YELLOW = "\033[33;1m"  # Bright yellow for warnings
    GREEN = "\033[32m"  # Green for general information
    CYAN = "\033[36m"  # Cyan for less critical info
    BOLD = "\033[1m"  # Bold text

def color_text(text, color):
    """Apply color to text."""
    return f"{color}{text}{Colors.RESET}"

def format_time(log):
    """Extract and format time as HH:MM from a log line."""
    match = re.search(r"\b(\d{2}):(\d{2}):\d{2}\b", log)  # Match HH:MM:SS
    if match:
        return f"{match.group(1)}:{match.group(2)}"
    return "--:--"  # Default for missing time

@task
def logs(ctx, host, lines=50):
    """Fetches and displays logs from the specified host."""
    print(color_text(f"\nFetching logs from {host}...\n", Colors.GREEN))
    result = ctx.run(f"ssh {host} 'sudo journalctl -xe | tail -n {lines}'", hide=True)
    logs = result.stdout.splitlines()

    if not logs:
        print(color_text("No logs found.", Colors.CYAN))
        return

    for log in logs:
        timestamp = format_time(log)  # Extract and format time
        if "critical" in log.lower():  # Detect critical logs
            print(color_text(f"{timestamp} [CRITICAL] " + log, Colors.RED))
        elif "error" in log.lower():  # Detect errors
            print(color_text(f"{timestamp} [ERROR]    " + log, Colors.YELLOW))
        elif "warning" in log.lower():  # Detect warnings
            print(color_text(f"{timestamp} [WARNING]  " + log, Colors.CYAN))
        else:
            print(color_text(f"{timestamp} [INFO]     " + log, Colors.GREEN))
        
        print("")  # Add a blank line for separation

    print(color_text("\nLog fetching completed.\n", Colors.GREEN))
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

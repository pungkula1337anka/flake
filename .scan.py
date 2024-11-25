import os
import re
import tqdm 

def scan_directory_for_secrets(directory):
    """
    Scans a directory recursively for potential secrets using regex patterns.
    """
    findings = []
    
    # Common regex patterns for detecting secrets
    patterns = {
        "Generic API Key": r"[A-Za-z0-9_\-]{20,}",
        "JWT Token": r"eyJ[A-Za-z0-9-_=]+\.eyJ[A-Za-z0-9-_=]+\.?[A-Za-z0-9-_.+/=]*",
        "AWS Access Key": r"AKIA[0-9A-Z]{16}",
        "AWS Secret Key": r"(?<![A-Za-z0-9])[A-Za-z0-9/+=]{40}(?![A-Za-z0-9/+=])",
        "Base64 String": r"[A-Za-z0-9+/=]{40,}",
        "Private Key": r"-----BEGIN (RSA|EC|DSA|OPENSSH|PGP) PRIVATE KEY-----",
        "Password in Env Var": r"(PASSWORD|SECRET|TOKEN|KEY)\s*=\s*[\'\"]?[A-Za-z0-9\-_=\/\+]{8,}[\'\"]?",
    }

    # List all files to process
    all_files = []
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            # Skip binary and non-text files
            if re.search(r'\.(jpg|png|gif|mp4|mp3|zip|tar|gz|pdf|exe|dll)$', file):
                continue
            all_files.append(file_path)

    # Set up progress bar
    with tqdm(total=len(all_files), desc="Scanning Files", unit="file", ncols=100) as pbar:
        # Traverse through files with progress bar
        for file_path in all_files:
            try:
                with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
                    content = f.read()
                    for name, pattern in patterns.items():
                        matches = re.findall(pattern, content)
                        if matches:
                            findings.append(
                                f"{name} found in {file_path}:\n{matches}\n"
                            )
            except Exception as e:
                print(f"Could not read {file_path}: {e}")
            
            # Update progress bar
            pbar.update(1)

    return findings

# Specify the directory to scan
directory_to_scan = "/home/pungkula/flake"

# Perform the scan
results = scan_directory_for_secrets(directory_to_scan)

# Output the results
if results:
    print("\nPotential Secrets Found:")
    for result in results:
        print(result)
else:
    print("No secrets found.")


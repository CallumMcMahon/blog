+++
date = '2026-03-24T12:00:00Z'
draft = false
title = 'Supply Chain Attack in litellm 1.82.8 on PyPI'
+++

*Originally published on [FutureSearch](https://futuresearch.ai/blog/litellm-pypi-supply-chain-attack). I was the first to report this to PyPI, whose response led to the package being quarantined.*

**Update (12:30 UTC):** version 1.82.7 is also compromised, in addition to 1.82.8

**Update (13:03 UTC):** The [public GitHub issue](https://github.com/BerriAI/litellm/issues/24512) has been closed as "not planned" by the owner, and is spammed by hundreds of bots to dilute the discussion. The [author](https://github.com/krrishdholakia) of litellm has very likely been fully compromised.

**Update (20:15 UTC):** The compromised versions have been yanked, and the PyPI quarantine has been lifted. The package maintainers are [handling](https://github.com/BerriAI/litellm/issues/24518) the fallout.

At 10:52 UTC on March 24, 2026, [litellm](https://github.com/BerriAI/litellm) version 1.82.8 was published to PyPI. The release contains a malicious `.pth` file (`litellm_init.pth`) that **executes automatically on every Python process startup** when litellm is installed in the environment. No corresponding tag or release exists on the litellm GitHub repository — the package appears to have been uploaded directly to PyPI, bypassing the normal release process.

I discovered it when the package was pulled in as a transitive dependency by an MCP plugin running inside Cursor. The `.pth` launcher spawns a child Python process via `subprocess.Popen`, but because `.pth` files trigger on every interpreter startup, the child re-triggers the same `.pth` — creating an exponential fork bomb that crashed my machine. The fork bomb is actually a bug in the malware.

## What the malware does

The payload operates in three stages:

1. **Collection.** A Python script harvests sensitive files from the host: SSH private keys and configs, `.env` files, AWS / GCP / Azure credentials, Kubernetes configs, database passwords, `.gitconfig`, shell history, crypto wallet files, and anything matching common secret patterns. It also runs commands to dump environment variables and query cloud metadata endpoints (IMDS, container credentials).

2. **Exfiltration.** The collected data is encrypted with a hardcoded 4096-bit RSA public key using AES-256-CBC (random session key, encrypted with the RSA key), bundled into a tar archive, and POSTed to `https://models.litellm.cloud/` — a domain that is not part of legitimate litellm infrastructure.

3. **Lateral movement and persistence.** If a Kubernetes service account token is present, the malware reads all cluster secrets across all namespaces and attempts to create a privileged `alpine:latest` pod on every node in `kube-system`. Each pod mounts the host filesystem and installs a persistent backdoor at `/root/.config/sysmon/sysmon.py` with a systemd user service. On the local machine, it attempts the same persistence via `~/.config/sysmon/sysmon.py`.

## What you should do

**Check whether you're affected.** If you installed or upgraded litellm on or after March 24, 2026, check for version 1.82.8: run `pip show litellm`, inspect `uv` caches (`find ~/.cache/uv -name "litellm_init.pth"`), and check virtual environments in CI/CD.

**Remove the package and purge caches.** Delete litellm 1.82.8 from any affected environment. Purge your package manager cache (`rm -rf ~/.cache/uv` or `pip cache purge`) to prevent re-installation from cached wheels.

**Check for persistence.** Look for `~/.config/sysmon/sysmon.py` and `~/.config/systemd/user/sysmon.service`. If running in Kubernetes, audit `kube-system` for pods matching `node-setup-*` and review cluster secrets for unauthorized access.

**Rotate credentials.** Assume any credentials present on the affected machine are compromised: SSH keys, cloud provider credentials (GCP ADC, AWS access keys, Azure tokens), Kubernetes configs, API keys in `.env` files, and database passwords.

I reported this to PyPI (`security@pypi.org`) and emailed the litellm maintainers directly. The community is tracking the issue at [litellm #24512](https://github.com/BerriAI/litellm/issues/24512).
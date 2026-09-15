# Work Summary - willibroadngebi-lab - 2026-09-08

## Present
Willibroad Ngebi (`willibroadngebi-lab`)

## What I did today

### Environment setup
- Cloned the team infrastructure repo
- Synced my member branch with main throughout the day
- Reviewed and approved team PRs

### Security analysis - Firewall rule (Issue #8 / PB-05)
I identified a critical security vulnerability in `main.tf`.
The existing firewall rule `allow_traffic` permitted ALL protocols
from `0.0.0.0/0` (the entire internet) to both the jumphost and
primary machines. This meant every port on every machine was
reachable from anywhere in the world.

### Fix implemented
Replaced the single permissive rule with two specific rules:

1. `allow_ssh` - Only TCP port 22 (SSH) from the internet,
   targeting the jumphost only. The team can still connect
   via SSH but no other ports are exposed externally.

2. `allow_internal` - All protocols within the team subnet
   (10.0.2.0/24) only. Internal communication between team
   machines continues to work normally.

The fix was submitted as a PR, reviewed by two teammates,
and merged to main. GitHub Actions deployed the change
to GCP automatically via terraform apply.

### CTF flags
Participated in the flag exercise. Our team captured 2/2 flags:
- Flag 1: Found via publicly readable Terraform state bucket
- Flag 2: Found via the Looking Glass tool

This demonstrated in practice why the security fixes matter —
the state bucket vulnerability was a real exploitable weakness.

### SSH tunnel and internal platform access
- Set up SSH SOCKS5 proxy tunnel to the jumphost
- Configured Firefox to route through the tunnel
- Successfully accessed the internal Spectre platform
- Viewed team flags and leaderboard

## Security principle applied
Principle of least privilege — only allow what is strictly
necessary. The firewall fix reduced the attack surface from
every port on every machine to only SSH on the jumphost.

## Pending
- Waiting for other team PRs to be reviewed and merged
- Continue Blue Team security review in next workshop

# Work Summary - willibroadngebi-lab - 2026-09-14

## Present
Willi Broad Ngebi (`willibroadngebi-lab`)

## What I did today

### Branch synchronisation
- Synced member branch with main (large merge — 603 insertions
  covering team work summaries, connection guides, backlog updates,
  bootstrap security changes and documentation)

### Internal platform access
- Set up SSH SOCKS5 proxy tunnel to the jumphost (34.51.183.245)
- Troubleshot proxy configuration between WSL and Windows Firefox
- Successfully accessed the internal Spectre platform at
  https://spectre.itsx25.chas-lab.dev via browser
- Viewed team flags, leaderboard and platform features

### PR review
- Reviewed and synced with team PRs merged to main today

## What I learned today

### SSH SOCKS proxy
- How to create a SOCKS5 proxy tunnel using SSH -D flag
- Why WSL tunnels require using the WSL IP (not 127.0.0.1)
  when connecting from Windows browsers
- How Zoom and other applications can conflict with proxy ports
- How to run SSH tunnel in background using -f flag

### Security insights
- The TF state flag proved in practice that a publicly readable
  state bucket is a real exploitable vulnerability
- The Looking Glass flag showed that internal tools need
  proper input validation and access controls

## Connection to security backlog
The platform access exercise directly validated our security
findings — particularly the state bucket vulnerability (PB-02)
which was exploitable in a real CTF scenario.

## Instance management
- team2-jumphost was found TERMINATED (stopped by daily schedule)
- Started manually: gcloud compute instances start team2-jumphost
  --project=itsx25-lab --zone=europe-north2-b
- External IP confirmed: 34.51.183.245
- Connect via: gcloud compute ssh team2-jumphost
  --project=itsx25-lab --zone=europe-north2-b

## Headscale Installation - 2026-09-14
- Installed Headscale v0.29.3 on team2-jumphost
- Installation method: downloaded official Debian package from GitHub
- Version confirmed: headscale version v0.29.3
- Headscale acts as the control server for the team Tailnet
- Next steps: DNS registration via Spectre, config.yaml setup,
  Tailscale client installation on team devices
- Team members do NOT need to reinstall Headscale - 
  only need to install Tailscale client on their own devices


## Pending
- Monitor merged PRs and continue Blue Team security review
- Contribute to remaining open issues in the backlog

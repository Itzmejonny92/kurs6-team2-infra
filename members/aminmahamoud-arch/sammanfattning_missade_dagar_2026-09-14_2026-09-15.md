# Sammanfattning för Amin - 2026-09-14 och 2026-09-15

Detta dokument sammanfattar de två Blue Team-dagar som Amin inte deltog i.
Syftet är att göra det möjligt att förstå gruppens beslut och ansluta den egna
arbetsstationen utan att behöva göra om teamets gemensamma serverarbete.

## Status före de två dagarna

Teamets Terraform-infrastruktur och CI/CD-pipeline fanns redan i GCP. GitHub
Actions använde Workload Identity Federation (WIF), vilket gjorde att
långlivade service account-nycklar inte längre behövdes i GitHub Secrets.

## Arbete den 2026-09-14

- WIF-migreringen kontrollerades efter att de gamla användarhanterade nycklarna
  hade tagits bort.
- Jumphosten migrerades från SSH-nycklar i instansmetadata till OS Login.
- `enable-oslogin` aktiverades och projektets metadatahanterade SSH-nycklar
  blockerades.
- Ett dedikerat service account kopplades till jumphosten.
- En gemensam anslutningsguide för GCP, OS Login, SSH och SOCKS5 skapades.
- Headscale `0.29.3` installerades manuellt på jumphosten. Den manuella
  installationen följs fortsatt upp i issue #41 för att göras reproducerbar.

## Arbete den 2026-09-15

### Metadata och instansidentitet

- GCP Metadata Service inspekterades från jumphosten.
- Kontrollen visade att OS Login var aktivt och att något `ssh-keys`-attribut
  inte längre fanns i instansmetadata.
- Skillnaden mellan en persons lokala GCP-identitet och VM-instansens service
  account verifierades med Secret Manager utan att hemlighetens innehåll
  dokumenterades.

### Headscale och Tailscale

- Headscale konfigurerades med serveradressen
  `https://team2.itsx25.chas-lab.dev`.
- Headscale är aktivt på jumphosten och använder `team2.arpa` som intern
  basdomän.
- Tailscale installerades och jumphosten registrerades i teamets Tailnet.
- Personliga Headscale-användare och enheter skapades för Jonny, Lasse, Fajk,
  Tim och Willibroad.
- Samtliga fem närvarande medlemmars enheter var online vid slutkontrollen.
- SSH från Jonnys arbetsstation till jumphosten via Tailnet verifierades.

### Brandvägg och steg 6

PR #49 förbereder följande begränsningar enligt workshopens steg 6:

- Headscale på TCP 8080 tillåts endast från utbildarens reverse proxy
  `10.0.0.2/32`.
- SSH på TCP 22 tillåts endast från instruktörsnätet `10.0.0.0/24`.
- Medlemmarnas fortsatta åtkomst sker via det krypterade Tailnet.

Ändringarna ska inte betraktas som driftsatta förrän PR:n är granskad, mergad,
Terraform-apply är godkänd och en efterkontroll har genomförts.

## Det här behöver Amin göra

### 1. Läs gemensam dokumentation

- [Projektets README](../../README.md)
- [Gemensam anslutningsguide](../../docs/gemensam_anslutningsguide.md)
- [Product Backlog](../../docs/product_backlog.md)
- [PR #49](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/49)

### 2. Synka din branch

Kör från repots rot:

```bash
git fetch origin
git switch member/aminmahamoud-arch
git pull --ff-only origin main
```

Kontrollera alltid `git status` före egna ändringar.

### 3. Kontrollera personlig GCP- och OS Login-åtkomst

Logga in med ditt eget Chas Academy-konto:

```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project itsx25-lab
```

Amins verifierade Chas Academy-adress behöver läggas till i `os_admin_users`
via en granskad pull request. Dela endast den publika SSH-nyckeln och aldrig den
privata nyckeln.

### 4. Installera Tailscale lokalt

Följ steg 8 i den gemensamma anslutningsguiden. På Ubuntu eller WSL:

```bash
curl -fsSL https://tailscale.com/install.sh -o /tmp/tailscale-install.sh
sudo sh /tmp/tailscale-install.sh
```

### 5. Skapa användaren `amin`

En administratör på jumphosten kontrollerar först att användaren saknas och
skapar den sedan en gång:

```bash
sudo headscale users list
sudo headscale users create amin
```

### 6. Anslut Amins arbetsstation

Kör lokalt:

```bash
sudo tailscale up \
  --login-server https://team2.itsx25.chas-lab.dev \
  --hostname amin-workstation
```

Registreringssidan visar ett tillfälligt auth-id. Registrera enheten på
jumphosten under användaren `amin` enligt den gemensamma guiden. Auth-id:t får
inte sparas i repot eller skickas i en öppen chatt.

### 7. Verifiera resultatet

Kör lokalt:

```bash
tailscale status
tailscale ping team2-jumphost
```

En administratör kontrollerar därefter att `amin-workstation` ligger under
användaren `amin` och är online.

## Säkerhet att komma ihåg

- Skapa inte någon lokal service account-nyckel.
- Dela aldrig privata SSH-nycklar, auth-id:n, tokens eller hemlighetsvärden.
- Läs Terraform-planen och använd teamets PR-flöde före driftsättning.
- Kör Headscale-administrationskommandon på jumphosten med `sudo`.
- Använd `team2.itsx25.chas-lab.dev` för Headscale och
  `spectre.itsx25.chas-lab.dev` endast för Spectre-portalen.

